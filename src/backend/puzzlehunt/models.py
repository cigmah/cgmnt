from django.db import models
from django.contrib.auth.models import AbstractUser
import datetime
from pytz import timezone

class User(AbstractUser):
    email = models.EmailField(max_length=254, unique=True)

    EMAIL_FIELD = 'email'

class Theme(models.Model):

    def __str__(self):
        return self.theme

    R = 'R'
    M = 'M'
    S = 'S'

    THEME_SETS = (
        (R, 'Regular'),
        (M, 'Meta'),
        (S, 'Sample'),
    )

    def open_datetime_func():
        return datetime.datetime.now(timezone('UTC'))

    theme = models.CharField(max_length=50, unique=True)
    theme_set = models.CharField(max_length=2, choices=THEME_SETS, default=S)
    tagline = models.CharField(max_length=300)
    open_datetime = models.DateTimeField(default=open_datetime_func)

class Puzzle(models.Model):

    def __str__(self):
        return self.title

    A = 'A'
    B = 'B'
    C = 'C'
    M = 'M'

    PUZZLE_SETS = (
        (A, 'Abstract'),
        (B, 'Beginner'),
        (C, 'Challenge'),
        (M, 'Meta'),
    )

    def get_theme(self):
        return self.theme_id

    theme_id = models.ForeignKey(Theme, on_delete=models.CASCADE)
    puzzle_set = models.CharField(max_length=2, choices=PUZZLE_SETS, default=A)
    video_link = models.TextField(blank=True)
    image_link = models.TextField()
    title = models.CharField(max_length=30)
    body = models.TextField()
    statement = models.TextField()
    puzzle_input = models.TextField(blank=True)
    references = models.TextField()
    answer = models.CharField(max_length=30)
    explanation = models.TextField()


class Submission(models.Model):

    def __str__(self):
        return "{}-{}".format(self.user_id, str(self.submission_datetime))

    def submission_datetime_func():
        return datetime.datetime.now(timezone('UTC'))

    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    puzzle_id = models.ForeignKey(Puzzle, on_delete=models.CASCADE)
    submission_datetime = models.DateTimeField(default=submission_datetime_func)
    submission = models.TextField()
    is_response_correct = models.BooleanField()
    points = models.IntegerField()

# I should have made this singular instead of plural, but I'd already made the migrations and was too scared I break it...
class Comments(models.Model):

    def posted_datetime_func():
        return datetime.datetime.now(timezone('UTC'))

    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    puzzle_id = models.ForeignKey(Puzzle, on_delete=models.CASCADE)
    comment = models.TextField()
    timestamp = models.DateTimeField(default=posted_datetime_func)

class Message(models.Model):

    def __str__(self):
        return self.subject

    email = models.CharField(max_length=100, blank=True)
    name = models.CharField(max_length=50, blank=True)
    subject = models.CharField(max_length=100)
    body = models.TextField()
    is_read = models.BooleanField(default=False)

class Prize(models.Model):
    A = 'A'
    B = 'B'
    C = 'C'
    G = 'G'
    P = 'P'

    PRIZE_SETS = (
        (A, 'Abstract'),
        (B, 'Beginner'),
        (C, 'Challenge'),
        (G, 'Grand'),
        (P, 'Puzzle')
    )

    def awarded_datetime_func():
          return datetime.datetime.now(timezone('UTC'))
    
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    awarded_datetime = models.DateTimeField(default=awarded_datetime_func)
    prize_type = models.CharField(max_length=2, choices=PRIZE_SETS, default=P)
    note = models.TextField()
