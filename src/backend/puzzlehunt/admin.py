from django.contrib import admin
from .models import User, Puzzle, Submission, Theme, Message, Prize, Comments
from django.contrib.auth.admin import UserAdmin

# Register your models here.

admin.site.register(User, UserAdmin)

class ThemeAdmin(admin.ModelAdmin):
    list_display = ('id', 'theme', 'open_datetime')

class PuzzleAdmin(admin.ModelAdmin):
    list_display = ('id', 'theme_id', 'puzzle_set', 'title')

class SubmissionAdmin(admin.ModelAdmin):
    list_display = ('user_id', 'puzzle_id', 'submission_datetime', 'is_response_correct', 'points')

class MessageAdmin(admin.ModelAdmin):
    list_display = ('subject', 'name', 'email', 'is_read')

class CommentAdmin(admin.ModelAdmin):
    list_display = ('user_id', 'puzzle_id', 'comment', 'timestamp')

class PrizeAdmin(admin.ModelAdmin):
    list_display = ('user_id', 'awarded_datetime', 'prize_type')

admin.site.register(Puzzle, PuzzleAdmin)
admin.site.register(Submission, SubmissionAdmin)
admin.site.register(Theme, ThemeAdmin)
admin.site.register(Message, MessageAdmin)
admin.site.register(Prize, PrizeAdmin)
admin.site.register(Comments, CommentAdmin)
