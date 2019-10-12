from rest_framework.test import APIRequestFactory
from django.test import TestCase
from django.core import mail
from puzzlehunt.models import *
from datetime import datetime, timedelta
from pytz import timezone
import time
import re
import sys

# Create your tests here.

class TestHelper():

    CODE_LENGTH = 6
    DEFAULT_EMAIL = 'cigmah.noreply@gmail.com'
    DEFAULT_USERNAME = 'test'

    def sendCode(test, email, username='test'):
        return test.client.post('/auth/email/', {"email":email})

    def getCode(test, email):
        TestHelper.sendCode(test, email)
        # retrieve last email
        code = re.findall(r'(\d{6})', mail.outbox[-1].body)[0]
        return code

    def authCode(test, code):
        return test.client.post('/callback/auth/', {"token":code})

    def authEmail(test, email):
        code = TestHelper.getCode(test, email)
        return TestHelper.authCode(test, code)

    def postMessage(test, data):
        return test.client.post('/message/', data)

    def getPuzzlesUser(test, token):
        return test.client.get('/puzzles/', HTTP_AUTHORIZATION = "Token "+ token)

    def getPuzzlesPublic(test):
        return test.client.get('/puzzles/')

    def getPuzzleDetailPublic(test, puzzle_id):
        return test.client.get('/puzzles/{}/'.format(puzzle_id))

    def getPuzzleDetailUser(test, puzzle_id, token):
        return test.client.get('/puzzles/{}/'.format(puzzle_id), HTTP_AUTHORIZATION = "Token "+ token)

    def getStats (test, username, token):
        return test.client.get(f'/stats/{username}/', HTTP_AUTHORIZATION = "Token "+ token)

    def comment(test, email, puzzleId, text):
        token = TestHelper.authEmail(test, email).data['token']

        return test.client.post('/puzzles/{}/comment/'.format(puzzleId), {'comment':text}, HTTP_AUTHORIZATION = 'Token '+ token)


    def submit(test, email, puzzleId, answer):
        token = TestHelper.authEmail(test, email).data['token']
        
        return test.client.post('/submissions/{}/'.format(puzzleId), {'submission':answer}, HTTP_AUTHORIZATION = 'Token '+ token)

    def confirmScoresOrder(test, data, keyword):
        leaderboardLength = len(data)
        test.assertTrue(leaderboardLength>= 0)
        if (leaderboardLength > 0):
            # test descending order by total
            previousScore = sys.maxsize
            for entry in data:
                score = int(entry[keyword])
                test.assertTrue(score <= previousScore)
                previousScore = score


class UsersTest(TestCase):
    userId=0
    
         
    def setUp(self):
        User.objects.create(email=TestHelper.DEFAULT_EMAIL, username=TestHelper.DEFAULT_USERNAME, first_name="first", last_name="last")
        User.objects.create(email='failed@failed.com', username="failed", first_name="failed", last_name="failed")
        UsersTest.userId = User.objects.get(email=TestHelper.DEFAULT_EMAIL).id
        Theme.objects.create(theme = "default", tagline = "none", open_datetime = datetime.now(timezone('UTC')) - timedelta(days=2))
        Theme.objects.create(theme = "regular", tagline = "none", theme_set = "R", open_datetime = datetime.now(timezone('UTC')) - timedelta(days=2))
        Theme.objects.create(theme = "unopened", tagline = "none", open_datetime = datetime.now(timezone('UTC')) + timedelta(days=2))

        Puzzle.objects.create(theme_id = Theme.objects.get(theme="default"), title = "new puzzle", body = "Sample Text", statement = "results", answer = "yes", explanation = "no", image_link="imagelink")
        Puzzle.objects.create(theme_id = Theme.objects.get(theme="unopened"), title = "unopened puzzle", body = "Sample Text", statement = "results", answer = "yes", explanation = "no", image_link="imagelink", video_link="erwer")
        Puzzle.objects.create(theme_id = Theme.objects.get(theme="regular"), title = "regular puzzle", body = "Sample Text", statement = "results", answer = "yes", explanation = "no", image_link="imagelink")

    # create user
    def testRegisterEmail_valid(self):  
        response = self.client.post('/users/', {"email":"a@a.com", "username":"a", "first_name":"a", "last_name":"a"})
        self.assertEqual(response.data, {"username":"a","email":"a@a.com","first_name":"a","last_name":"a"})

    def testRegisterEmail_invalid(self):
        response = self.client.post('/users/', {"email":"b", "username":"b", "first_name":"bb", "last_name":"bb"})
        self.assertNotEqual(response.data, {"username":"b","email":"b","first_name":"bb","last_name":"bb"})

    def testRegisterEmail_empty(self):
        response = self.client.post('/users/', {"email":"", "username":"b", "first_name":"bb", "last_name":"bb"})
        self.assertNotEqual(response.data, {"username":"b","email":"b","first_name":"bb","last_name":"bb"})

    # send authentication email
    def testSendCodeEmail_valid(self):
        response = TestHelper.sendCode(self, TestHelper.DEFAULT_EMAIL)
        self.assertEqual(response.data, {"detail":"A login token has been sent to your email."})
        
        # check received email
        self.assertEqual(len(mail.outbox),1)
        self.assertEqual(mail.outbox[0].subject, 'CIGMAH Login Token')

    def testSendCodeEmail_invaid(self):
        response = TestHelper.sendCode(self, "a@a.com")
        self.assertNotEqual(response.data, {"detail":"A login token has been sent to your email."})
        self.assertEqual(len(mail.outbox),0)

    def testSendCodeEmail_empty(self):
        response = TestHelper.sendCode(self, "")
        self.assertNotEqual(response.data, {"detail":"A login token has been sent to your email."})
        self.assertEqual(len(mail.outbox),0)

    # authenticate with token
    def testAuthCode_valid(self):
        response = TestHelper.authEmail(self, TestHelper.DEFAULT_EMAIL)
        self.assertIsInstance(response.data['token'], str)
        self.assertIsInstance(response.data['email'], str)
        self.assertIsInstance(response.data['username'], str)

    def testAuthCode_invalid(self):
        code = '000000'
        response = TestHelper.authCode(self, code)
        self.assertNotIsInstance(response.data['token'], str)

    def testAuthCode_empty(self):
        code = ''
        response = TestHelper.authCode(self, code)
        self.assertNotIsInstance(response.data['token'], str)

    def testAuthCode_multipleCodes(self):
        TestHelper.getCode(self, TestHelper.DEFAULT_EMAIL)
        response = TestHelper.authEmail(self, TestHelper.DEFAULT_EMAIL)
        self.assertIsInstance(response.data['token'], str)

    def testAuthCode_multipleAuths(self):
        TestHelper.authEmail(self, TestHelper.DEFAULT_EMAIL)
        response = TestHelper.authEmail(self, TestHelper.DEFAULT_EMAIL)
        self.assertIsInstance(response.data['token'], str)

    # user
    def testStats_withAuthWithoutSubmission(self):

        response = TestHelper.authEmail(self, TestHelper.DEFAULT_EMAIL)
        token = response.data['token']
        response = TestHelper.getStats(self, TestHelper.DEFAULT_USERNAME, token)

        self.assertIn('username', response.data)
        self.assertIn('num_submit', response.data)
        self.assertIn('num_solved', response.data)
        self.assertIn('points', response.data)
        self.assertIn('rank', response.data)
        self.assertIn('num_prizes', response.data)
        self.assertIn('submissions', response.data)
        assert(len(response.data.get('submissions')) == 0)

    def testStats_withAuthWithSubmission(self):

        puzzle = Puzzle.objects.get(title='new puzzle', theme_id__open_datetime__lte=datetime.now(timezone('UTC')))
        response = TestHelper.submit(self, TestHelper.DEFAULT_EMAIL,  puzzle.id, 'yes')
        self.assertEqual(True, response.data['is_response_correct'])

        response = TestHelper.authEmail(self, TestHelper.DEFAULT_EMAIL)
        token = response.data['token']
        response = TestHelper.getStats(self, TestHelper.DEFAULT_USERNAME, token)

        self.assertIn('username', response.data)
        self.assertIn('num_submit', response.data)
        self.assertIn('num_solved', response.data)
        self.assertIn('points', response.data)
        self.assertIn('rank', response.data)
        self.assertIn('num_prizes', response.data)
        self.assertIn('submissions', response.data)
        assert(len(response.data.get('submissions')) == 1)

    def testStats_withAuthWithIncorrectSubmission(self):

        puzzle = Puzzle.objects.get(title='new puzzle', theme_id__open_datetime__lte=datetime.now(timezone('UTC')))
        response = TestHelper.submit(self, TestHelper.DEFAULT_EMAIL,  puzzle.id, 'no')
        self.assertEqual(False, response.data['is_response_correct'])

        response = TestHelper.authEmail(self, TestHelper.DEFAULT_EMAIL)
        token = response.data['token']
        response = TestHelper.getStats(self, TestHelper.DEFAULT_USERNAME, token)

        self.assertIn('username', response.data)
        self.assertIn('num_submit', response.data)
        self.assertIn('num_solved', response.data)
        self.assertIn('points', response.data)
        self.assertIn('rank', response.data)
        self.assertIn('num_prizes', response.data)
        self.assertIn('submissions', response.data)
        assert(len(response.data.get('submissions')) == 1)

    def testStats_noAuth(self):

        response = self.client.get(f'/stats/{TestHelper.DEFAULT_USERNAME}/')

        self.assertIn('username', response.data)
        self.assertIn('num_submit', response.data)
        self.assertIn('num_solved', response.data)
        self.assertIn('points', response.data)
        self.assertIn('rank', response.data)
        self.assertIn('num_prizes', response.data)
        self.assertNotIn('submissions', response.data)



    # get puzzles

    def testGetPuzzlesPublic(self):
        response = TestHelper.getPuzzlesPublic(self)
        self.assertEqual(response.status_code, 200)
        self.assertIn('next', response.data)
        self.assertIn('num_registrations', response.data)
        self.assertIn('num_submissions', response.data)
        assert(len(response.data.get('puzzles')) > 0)
        assert('theme' in response.data.get('next').keys())

    def testGetPuzzlesUser(self):
        response = TestHelper.authEmail(self, TestHelper.DEFAULT_EMAIL)
        token = response.data['token']
        response = TestHelper.getPuzzlesUser(self, token)
        self.assertEqual(response.status_code, 200)
        self.assertIn('next', response.data)
        self.assertIn('num_registrations', response.data)
        self.assertIn('num_submissions', response.data)
        assert(len(response.data.get('puzzles')) > 0)
        assert('theme' in response.data.get('next').keys())
        assert('is_solved' in response.data.get('puzzles')[0].keys())

    # get puzzle details

    def testGetPuzzleDetailPublic(self):
        puzzle = Puzzle.objects.get(title='new puzzle', theme_id__open_datetime__lte=datetime.now(timezone('UTC')))
        response = TestHelper.getPuzzleDetailPublic(self, puzzle.id)
        self.assertEqual(response.status_code, 200)
        self.assertIn("title", response.data)
        self.assertIn('solved', response.data)
        self.assertIn('correct', response.data)
        self.assertIn('incorrect', response.data)
        self.assertNotIn("answer", response.data)
        self.assertNotIn("comments", response.data)

    def testGetPuzzleDetailUnsolved(self):
        puzzle = Puzzle.objects.get(title='new puzzle', theme_id__open_datetime__lte=datetime.now(timezone('UTC')))
        response = TestHelper.authEmail(self, TestHelper.DEFAULT_EMAIL)
        token = response.data['token']
        response = TestHelper.getPuzzleDetailUser(self, puzzle.id, token)
        self.assertEqual(response.status_code, 200)
        self.assertIn("title", response.data)
        self.assertNotIn("answer", response.data)
        self.assertNotIn("comments", response.data)

    def testGetPuzzleDetailSolved(self):
        puzzle = Puzzle.objects.get(title='new puzzle', theme_id__open_datetime__lte=datetime.now(timezone('UTC')))
        response = TestHelper.submit(self, TestHelper.DEFAULT_EMAIL,  puzzle.id, 'yes')
        self.assertEqual(True, response.data['is_response_correct'])

        response = TestHelper.authEmail(self, TestHelper.DEFAULT_EMAIL)
        token = response.data['token']

        response = TestHelper.getPuzzleDetailUser(self, puzzle.id, token)

        self.assertEqual(response.status_code, 200)
        self.assertIn("title", response.data)
        self.assertIn("answer", response.data)
        self.assertIn("comments", response.data)

    # submissions
    def testSubmission_correct(self):
        puzzle = Puzzle.objects.get(title='new puzzle', theme_id__open_datetime__lte=datetime.now(timezone('UTC')))
        response = TestHelper.submit(self, TestHelper.DEFAULT_EMAIL,  puzzle.id, 'yes')

        self.assertEqual(UsersTest.userId, response.data['user_id'])
        self.assertEqual(puzzle.id, response.data['puzzle_id'])
        self.assertEqual(True, response.data['is_response_correct'])

    def testSubmission_incorrect(self):
        puzzle = Puzzle.objects.get(title='new puzzle', theme_id__open_datetime__lte=datetime.now(timezone('UTC')))
        response = TestHelper.submit(self, TestHelper.DEFAULT_EMAIL, puzzle.id, 'no')
        self.assertEqual(UsersTest.userId, response.data['user_id'])
        self.assertEqual(puzzle.id, response.data['puzzle_id'])                          
        self.assertEqual(False, response.data['is_response_correct'])
    
    def testSubmission_invalidPuzzle(self):
        response = TestHelper.submit(self, TestHelper.DEFAULT_EMAIL, 0, 'yes')                             
        self.assertEqual({"message": "This puzzle does not exist."}, response.data)

    def testSubmission_unOpenedPuzzle(self):
        puzzle = Puzzle.objects.get(title='unopened puzzle')
        response = TestHelper.submit(self, TestHelper.DEFAULT_EMAIL, puzzle.id, 'yes')                             
        self.assertEqual({"message": "This puzzle does not exist."}, response.data)

    # get leaderboard
    def testGetLeaderboard(self):
        puzzle = Puzzle.objects.get(title='new puzzle', theme_id__open_datetime__lte=datetime.now(timezone('UTC')))
        TestHelper.submit(self, TestHelper.DEFAULT_EMAIL, puzzle.id, 'yes')
        TestHelper.submit(self, 'failed@failed.com', puzzle.id, 'yes')
        token =  TestHelper.authEmail(self, TestHelper.DEFAULT_EMAIL).data['token']
        response = self.client.get('/leaderboard/', HTTP_AUTHORIZATION = 'Token '+ token)
        TestHelper.confirmScoresOrder(self, response.data, 'total_grand')

    # test message
    def testMessageFull(self):
        response = self.client.post('/message/', {"name": "Test", "email": "test@email.com", "subject": "Test Subject", "body": "Test body text."})
        self.assertEqual(response.status_code, 201)


    # test comment
    def testComment_withAuth_solved(self):
        puzzle = Puzzle.objects.get(title='new puzzle', theme_id__open_datetime__lte=datetime.now(timezone('UTC')))
        response = TestHelper.submit(self, TestHelper.DEFAULT_EMAIL,  puzzle.id, 'yes')
        self.assertEqual(True, response.data['is_response_correct'])

        comment = "this is a test 'comment'"
        response = TestHelper.comment(self, TestHelper.DEFAULT_EMAIL, puzzle.id, comment)
        self.assertEqual(response.status_code, 201)
        assert(response.data[0].get("comment") == comment )

    def testComment_withAuth_unsolved(self):
        puzzle = Puzzle.objects.get(title='new puzzle', theme_id__open_datetime__lte=datetime.now(timezone('UTC')))
        response = TestHelper.submit(self, TestHelper.DEFAULT_EMAIL,  puzzle.id, 'no')
        self.assertEqual(False, response.data['is_response_correct'])

        response = TestHelper.comment(self, TestHelper.DEFAULT_EMAIL, puzzle.id, "this is a test 'comment'")
        self.assertEqual(response.status_code, 403)

    def testComment_noAuth(self):
        puzzle = Puzzle.objects.get(title='new puzzle', theme_id__open_datetime__lte=datetime.now(timezone('UTC')))
        response = TestHelper.submit(self, TestHelper.DEFAULT_EMAIL,  puzzle.id, 'yes')
        self.assertEqual(True, response.data['is_response_correct'])

        response = self.client.post(f'/puzzles/{str(puzzle.id)}/comment/', {"text": "# This is some (test)[https://google.com] with *some* markdown formatting\n ```python\n````"})
        self.assertEqual(response.status_code, 401)
