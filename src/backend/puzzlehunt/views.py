import re
from django.shortcuts import render
from rest_framework import status, viewsets
from rest_framework.authentication import BasicAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.contrib.auth.models import Group
from django.db.models import Sum, Case, When
from django.core.exceptions import ObjectDoesNotExist
from django.db.models.functions import Coalesce
from puzzlehunt.models import User, Puzzle, Submission, Theme, Prize, Comments
from puzzlehunt.serializers import MessageSerializer, UserSerializer, MiniPuzzlePublicSerializer, MiniPuzzleUserSerializer, PuzzleSerializer, UnsolvedPuzzleSerializer, SubmissionSerializer, MiniSubmissionSerializer, CensoredAggregateSubmissionSerializer, CensoredSubmissionSerializer, ThemeSerializer, PrizeSerializer, CensoredSetSubmissionSerializer, CommentSerializer, SaveCommentSerializer
from datetime import datetime, timedelta
from pytz import timezone
from math import exp

class UserViewSet(viewsets.ReadOnlyModelViewSet):
    """
    This viewset automatically provides `list` and `detail` actions.
    """
    queryset = User.objects.all()
    serializer_class = UserSerializer

@api_view(['POST'])
def post_message(request):
    """ Adds a new message.

    Args:
        - name (optional) (string)
        - email (optional) (string)
        - subject (required) (string)
        - body (required) (string)
    """

    serialized = MessageSerializer(data=request.data)

    if serialized.is_valid():
        serialized.save()
        return Response(serialized.data, status=status.HTTP_201_CREATED)
    else:
        return Response(serialized._errors, status=status.HTTP_400_BAD_REQUEST)

def add_field(dict_list, field_key, field_value):
    """ Helper function to add a field to every item of dictionary list.
    """
    for item in dict_list:
        item.update({field_key: field_value})

@api_view(['GET'])
def get_puzzles(request):
    """ Gets a list of all open puzzles.

    If the user is authenticated, then add an additional field, "is_complete", to each puzzle.

    Returns:
        - 200
            A list of "mini" puzzle information, each of which has the following fields:

            - id (int)
            - theme (string)
            - puzzle_set (char, one of "A", "B", "C", "M")
            - title
            - image_link (string)
            - (if authenticated) is_solved (boolean)

    """

    now = datetime.now(timezone('UTC'))
    user = request.user
    if user.is_authenticated:
        # TODO figure out if this can be done with custom join or select/prefetch_related
        solved = Submission.objects.filter(user_id=user.id, is_response_correct=True)\
                                       .values_list("puzzle_id")

        puzzles = Puzzle.objects.filter(theme_id__open_datetime__lte=now)\
                                .order_by('id')

        for puzzle in puzzles:
            puzzle.is_solved = (puzzle.id,) in solved

        serializer = MiniPuzzleUserSerializer(puzzles, many=True)


    else:
        puzzles = Puzzle.objects.filter(theme_id__open_datetime__lte=now)\
                                        .order_by('id')
        serializer = MiniPuzzlePublicSerializer(puzzles, many=True)

    next_open = Theme.objects.filter(open_datetime__gte=now)\
                             .order_by('open_datetime')\
                             .first()
    next_serializer = ThemeSerializer(next_open)

    num_submissions = Submission.objects.all().count()
    num_registrations = User.objects.all().count()

    content = {
        "puzzles" : serializer.data,
        "next" : next_serializer.data,
        "num_registrations": num_registrations,
        "num_submissions": num_submissions,
    }

    return Response(content, status=status.HTTP_200_OK)

@api_view(['GET'])
def get_puzzle_detail(request, puzzle_id):
    """ Gets the full puzzle information for a puzzle (only open puzzles).

    If a user is not authenticated, then does not return the answer/explanation.

    If the user is authenticated, then
    - Adds an additional field, "is_solved"
    - If "is_solved", then adds the answer and explanation fields.


    """

    now = datetime.now(timezone('UTC'))
    user = request.user

    try:
        if user.is_authenticated:
            solved = Submission.objects.filter(user_id=user.id, puzzle_id=puzzle_id, is_response_correct=True)

            puzzle = Puzzle.objects.filter(theme_id__open_datetime__lte=now, id=puzzle_id).get()

            if solved.exists():
                puzzle.is_solved = True
                puzzle_serializer = PuzzleSerializer(puzzle)

                comments = Comments.objects.filter(puzzle_id=puzzle.id).order_by('-timestamp')
                comments_serializer = CommentSerializer(comments[:20], many=True)
            else:
                puzzle.is_solved = False
                puzzle_serializer = UnsolvedPuzzleSerializer(puzzle)
                comments_serializer = False
        else:
            puzzle = Puzzle.objects.filter(theme_id__open_datetime__lte=now, id=puzzle_id).get()
            puzzle_serializer = UnsolvedPuzzleSerializer(puzzle)
            comments_serializer = False
    except ObjectDoesNotExist:
        return Response({"message": "This puzzle does not exist!"}, status=status.HTTP_404_NOT_FOUND)

    submitted = Submission.objects.filter(puzzle_id = puzzle_id)
    correct = submitted.filter(is_response_correct=True)
    num_correct = correct.filter(is_response_correct=True).count()
    num_incorrect = submitted.filter(is_response_correct=False).count()

    submissions = correct.order_by('submission_datetime')
    submissions_serializer = CensoredSubmissionSerializer(submissions[:5], many=True)

    content = puzzle_serializer.data
    if comments_serializer:
        content['comments'] = comments_serializer.data
    content['stats'] = {
        'leaderboard': submissions_serializer.data,
        'correct': num_correct,
        'incorrect': num_incorrect
    }
    return Response(content)

@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def post_comment(request, puzzle_id):
    """Adds a comment to a puzzle if solved.
    """
    user = request.user

    if user.is_authenticated:
        solved = Submission.objects.filter(user_id=user.id, puzzle_id=puzzle_id, is_response_correct=True)
        if solved.exists():
            data = request.data.copy()
            data['puzzle_id'] = puzzle_id
            data['user_id'] = user.id
            serialized = SaveCommentSerializer(data=data)
            if serialized.is_valid():
                serialized.save()
                comments = Comments.objects.filter(puzzle_id=puzzle_id).order_by('-timestamp')
                comments_serializer = CommentSerializer(comments[:20], many=True)
                return Response(comments_serializer.data, status=status.HTTP_201_CREATED)
            else:
                return Response({}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({}, status=status.HTTP_403_FORBIDDEN)
    else:
        return Response({}, status=status.HTTP_403_FORBIDDEN)

@api_view(['GET'])
def get_user_stats(request, username):
    user = request.user

    try:
        selected_user = User.objects.filter(username=username).get()
    except:
        return Response({"message": "This user does not exist!"}, status=status.HTTP_404_NOT_FOUND)

    submissions = Submission.objects
    user_submissions = submissions.filter(user_id=selected_user.id)
    num_submit = user_submissions.count()
    solved = user_submissions.filter(is_response_correct=True)
    num_solved = solved.count()
    points = solved.aggregate(Sum('points')).get("points__sum")
    if points is None:
        points = 0
    rank = submissions.filter(is_response_correct=True)\
                                    .values('user_id')\
                                    .annotate(total=Sum('points'))\
                                    .filter(total__gte=points)\
                                    .count()
    submissions = Submission.objects.filter(user_id=user.id).order_by('-submission_datetime')
    submissions_serializer = MiniSubmissionSerializer(submissions[:10], many=True)

    num_prizes = Prize.objects.filter(user_id=selected_user.id).count()

    content = {
        'username': username,
        'num_submit': num_submit,
        'num_solved': num_solved,
        'points': points,
        'rank': rank,
        'num_prizes': num_prizes,
    }

    if selected_user.username == user.username:
        content['submissions'] = submissions_serializer.data

    return Response(content, status=status.HTTP_200_OK)

@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def submit(request, puzzle_id):
    """ Gets a list, or adds a submission (user-facing).
    """

    user = request.user

    data = request.POST.copy()

    if not data:
        data = request.data

    if not data:
        return Response(status.HTTP_400_BAD_REQUEST)

    now = datetime.now(timezone('UTC'))

    all_submissions = Submission.objects.filter(puzzle_id=puzzle_id)

    submissions = all_submissions.filter(user_id=user.id)\
                                    .order_by('-submission_datetime')

    # Check puzzle has not already been solved
    if len(submissions.filter(is_response_correct=True)) > 0:
        content = {"message": "This puzzle has already been solved."}
        return Response(content, status=status.HTTP_403_FORBIDDEN)

    # Check puzzle is open
    try:
        puzzle = Puzzle.objects.select_related("theme_id")\
                               .get(id=puzzle_id,
                                    theme_id__open_datetime__lte=now)
    except ObjectDoesNotExist:
        content = {"message": "This puzzle does not exist."}
        return Response(content, status=status.HTTP_403_FORBIDDEN)

    # Check most recent submission not within 2 ** (n_prev - 1) minutes
    if len(submissions) > 0:
        n_prev = len(submissions)
        last_submission = submissions.first().submission_datetime
        wait_time = (60 * 2 ** (n_prev - 1))
        next_allowed = last_submission + timedelta(0, wait_time)

        if ((now - next_allowed).total_seconds() < 0):
            content = {
                "message": "Last submission was too recent.",
                "num_attempts": n_prev,
                "last_submission": last_submission,
                "wait_time_seconds": wait_time,
                "next_allowed": next_allowed
            }
            return Response(content, status=status.HTTP_412_PRECONDITION_FAILED)

    keep_regex = '[^A-Za-z0-9]+'
    answer = re.sub(keep_regex, '', puzzle.answer).lower()
    submission = re.sub(keep_regex, '', data.get('submission')).lower()

    # Replace any added data
    data['puzzle_id'] = puzzle_id
    data['is_response_correct'] = None
    data['points'] = None
    data['user_id'] = user.id
    data['submission_datetime'] = now

    if submission is not None:
        if submission == answer:
            data['is_response_correct'] = True

            theme_set = puzzle.theme_id.theme_set

            if theme_set == "S":
                data['points'] = 0

            else:
                points_prelim = 100 - all_submissions.filter(is_response_correct=True).count()
                if points_prelim > 0:
                    if puzzle.puzzle_set == "C":
                        data['points'] = 2 * points_prelim
                    elif puzzle.puzzle_set == "M":
                        data['points'] = 4 * points_prelim
                    else:
                        data['points'] = points_prelim
                else:
                    data['points'] = 0
        else:
            data['is_response_correct'] = False
            data['points'] = 0
    else:
        return Response(serialized._errors, status=status.HTTP_400_BAD_REQUEST)

    serialized = SubmissionSerializer(data=data)

    if serialized.is_valid():
        serialized.save()
        return Response(serialized.data, status=status.HTTP_201_CREATED)
    else:
        return Response(serialized._errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes((IsAuthenticated,))
def get_profile(request):
    """ Returns profile information for a user.
    """

    user = request.user
    now = datetime.now(timezone('UTC'))

    submissions = Submission.objects.select_related("puzzle_id").filter(user_id=user.id).order_by('-submission_datetime')
    submissions_serializer = MiniSubmissionSerializer(submissions, many=True)
    solved = submissions.filter(is_response_correct=True)

    try:
        num_solved = solved.count()
        points = solved.aggregate(Sum('points')).get("points__sum")
        if not points:
            points = 0

    except ObjectDoesNotExist:
        num_solved = 0
        points = 0

    content = {
        "submissions": submissions_serializer.data[:10],
        "num_solved" : num_solved,
        "points" : points,
    }

    return Response(content, status=status.HTTP_200_OK)


@api_view(['GET'])
def submissions_leaderboard(request):
    """ Gets a list of submissions, aggregated as a leaderboard.
    """

    submissions = Submission.objects.filter(is_response_correct=True)\
                                    .values('user_id__username')\
                                    .annotate(total_grand=Sum('points'))\
                                    .annotate(total_abstract=Coalesce(Sum(Case(When(puzzle_id__puzzle_set='A', then='points'))),0))\
                                    .annotate(total_beginner=Coalesce(Sum(Case(When(puzzle_id__puzzle_set='B', then='points'))),0))\
                                    .annotate(total_challenge=Coalesce(Sum(Case(When(puzzle_id__puzzle_set='C', then='points'))),0))\
                                    .annotate(total_meta=Coalesce(Sum(Case(When(puzzle_id__puzzle_set='M', then='points'))),0))\
                                    .order_by('-total_grand')
    serializer = CensoredAggregateSubmissionSerializer(submissions[:10], many=True)

    return Response(serializer.data)

@api_view(['POST'])
def add_user(request):
    """ Adds a new user.
    """

    serialized = UserSerializer(data=request.data)

    if serialized.is_valid():
        serialized.save()
        return Response(serialized.data, status=status.HTTP_201_CREATED)
    else:
        return Response(serialized._errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def get_prizes(request):
    """ Get a list of all prizes.
    """

    prizes = Prize.objects.all()
    serialized = PrizeSerializer(prizes, many=True)

    return Response(serialized.data)
