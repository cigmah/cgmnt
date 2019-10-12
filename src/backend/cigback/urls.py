"""cigback URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import include, path
from rest_framework import routers
from puzzlehunt import views
from django.contrib import admin, auth

admin.autodiscover()

# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path('', include('drfpasswordless.urls')),
    path(r'overseer/', admin.site.urls),
    path(r'message/', views.post_message),
    path(r'puzzles/', views.get_puzzles),
    path(r'puzzles/<int:puzzle_id>/comment/', views.post_comment),
    path(r'puzzles/<int:puzzle_id>/', views.get_puzzle_detail),
    path(r'stats/<str:username>/', views.get_user_stats),
    path(r'prizes/', views.get_prizes),
    path(r'submissions/<int:puzzle_id>/', views.submit),
    path(r'leaderboard/', views.submissions_leaderboard),
    path(r'users/', views.add_user),
    path(r'api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    path(r'accounts/login/', auth.views.LoginView.as_view(template_name='registration/login.html')),
]
