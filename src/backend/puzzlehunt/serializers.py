#!/usr/bin/env python
from puzzlehunt.models import User, Puzzle, Submission, Theme, Message, Prize, Comments
from rest_framework import serializers


# THEME SERIALIZERS

class ThemeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Theme
        fields = ('id', 'theme', 'theme_set', 'tagline', 'open_datetime')

class MiniThemeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Theme
        fields = ('id', 'theme', 'theme_set')


# PUZZLE SERIALIZERS

class PuzzleSerializer(serializers.ModelSerializer):
    theme = ThemeSerializer(read_only=True, source="theme_id")

    class Meta:
        model = Puzzle
        fields = ('id', 'theme_id', 'theme', 'puzzle_set', 'video_link', 'image_link', 'title', 'body', 'statement', 'puzzle_input', 'references', 'answer', 'explanation')


class MiniPuzzlePublicSerializer(serializers.ModelSerializer):
    theme = ThemeSerializer(source='theme_id', read_only=True)

    class Meta:
        model = Puzzle
        fields = ('id', 'theme', 'puzzle_set', 'title','image_link')

class MiniPuzzleUserSerializer(serializers.ModelSerializer):
    theme = ThemeSerializer(source='theme_id', read_only=True)
    is_solved = serializers.BooleanField(read_only=True)
    class Meta:
        model = Puzzle
        fields = ('id', 'theme', 'puzzle_set', 'title','image_link', 'is_solved')

class UnsolvedPuzzleSerializer(serializers.ModelSerializer):
    theme = ThemeSerializer(read_only=True, source="theme_id")

    class Meta:
        model = Puzzle
        fields = ('id', 'theme_id', 'theme', 'puzzle_set', 'video_link', 'image_link', 'title', 'body', 'statement', 'puzzle_input', 'references')

# USER SERIALIZERS

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('username', 'email', 'first_name', 'last_name')


class MiniUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('username',)

# SUBMISSION SERIALIZERS

class SubmissionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Submission
        fields = ('id', 'user_id', 'puzzle_id', 'submission_datetime', 'submission', 'is_response_correct', 'points')

class MiniSubmissionSerializer(serializers.ModelSerializer):
    user = MiniUserSerializer(read_only=True, source="user_id")
    puzzle = MiniPuzzlePublicSerializer(read_only=True, source="puzzle_id")
    class Meta:
        model = Submission
        fields = ('id', 'user', 'puzzle', 'submission_datetime', 'submission', 'is_response_correct', 'points')



class CensoredAggregateSubmissionSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user_id__username', read_only=True)
    total_grand = serializers.IntegerField(read_only=True)
    total_abstract = serializers.IntegerField(read_only=True)
    total_beginner = serializers.IntegerField(read_only=True)
    total_challenge = serializers.IntegerField(read_only=True)
    total_meta= serializers.IntegerField(read_only=True)
    class Meta:
        model = Submission
        fields = ('username', 'total_abstract', 'total_beginner', 'total_challenge', 'total_meta', 'total_grand')

class CensoredSubmissionSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user_id', read_only=True)
    puzzle = serializers.CharField(source='puzzle_id', read_only=True)
    class Meta:
        model = Submission
        fields = ('username', 'puzzle', 'submission_datetime', 'points')

class CensoredSubmissionSerializerWithTheme(serializers.ModelSerializer):
    username = serializers.CharField(source='user_id', read_only=True)
    puzzle = MiniPuzzlePublicSerializer(read_only=True, source="puzzle_id")
    class Meta:
        model = Submission
        fields = ('username', 'puzzle', 'submission_datetime', 'points')

class CensoredSetSubmissionSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user_id__username', read_only=True)
    total = serializers.IntegerField(read_only=True)
    puzzle_set = serializers.CharField()
    class Meta:
        model = Submission
        fields = ('puzzle_set', 'username', 'total')

# MESSAGE SERIALIZERS
class MessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Message
        fields = ('name', 'email', 'subject', 'body')

# COMMENTS SERIALIZERS
class CommentSerializer(serializers.ModelSerializer):
    username = serializers.CharField(read_only=True, source='user_id')
    class Meta:
        model = Comments
        fields = ('username', 'comment', 'timestamp')

class SaveCommentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Comments
        fields = ('user_id', 'puzzle_id', 'comment' )

# PRIZE SERIALIZERS
class PrizeSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user_id', read_only=True)
    class Meta:
        model = Prize
        fields = ('username', 'awarded_datetime', 'prize_type', 'note')
