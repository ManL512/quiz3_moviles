from django.urls import path
from . import views

urlpatterns = [
    path('register/', views.register),
    path('login/', views.login),
    path('fingerprint-login/', views.fingerprint_login),
    path('logout/', views.logout),
]
