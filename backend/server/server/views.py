#vies.py
import os
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import AccessToken, RefreshToken
from django.contrib.auth.models import User
from .models import UserToken
from .serializers import UserSerializer, SessionTokenSerializer
from datetime import timedelta, timezone

@api_view(['POST'])
def register(request):
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        user.set_password(request.data['password'])
        user.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def login(request):
    username = request.data.get('username')
    password = request.data.get('password')

    if not username or not password:
        return Response({"error": "Please provide both username and password."}, status=status.HTTP_400_BAD_REQUEST)

    user = User.objects.filter(username=username).first()
    if not user or not user.check_password(password):
        return Response({"error": "Invalid credentials."}, status=status.HTTP_400_BAD_REQUEST)

    session_token = AccessToken.for_user(user)
    session_token.set_exp(lifetime=timedelta(minutes=5))  # 5 minutes session token duration

    return Response({"session_token": str(session_token)}, status=status.HTTP_200_OK)

# Activar la huella
@api_view(['POST'])
def fingerprint_login(request):
    username = request.data.get('username')
    password = request.data.get('password')
    session_token = request.data.get('session_token')

    if not username or not password or not session_token:
        return Response({"error": "Please provide username, password, and session token."}, status=status.HTTP_400_BAD_REQUEST)

    # Verificar si las credenciales son válidas
    user = User.objects.filter(username=username).first()
    if not user or not user.check_password(password):
        return Response({"error": "Invalid credentials."}, status=status.HTTP_400_BAD_REQUEST)

    # Verificar si el token de sesión es válido
    try:
        access_token = AccessToken(session_token)
    except Exception as e:
        return Response({"error": "Invalid session token."}, status=status.HTTP_400_BAD_REQUEST)

    # Verificar si el token de sesión pertenece al usuario
    if access_token['user_id'] != user.id:
        return Response({"error": "Session token does not match user."}, status=status.HTTP_400_BAD_REQUEST)

    # Si todo es válido, devolver éxito
    return Response({"message": "Fingerprint login successful."}, status=status.HTTP_200_OK)


@api_view(['POST'])
def logout(request):
    # Remove both session and long-lived tokens
    username = request.data.get('username')
    password = request.data.get('password')

    if not username or not password:
        return Response({"error": "Please provide both username and password."}, status=status.HTTP_400_BAD_REQUEST)

    user = User.objects.filter(username=username).first()
    if not user or not user.check_password(password):
        return Response({"error": "Invalid credentials."}, status=status.HTTP_400_BAD_REQUEST)

    # Remove session token 
    # (No need to remove long-lived token, as it's meant to be used until expiration)
    user_token = UserToken.objects.filter(user=user).first()
    if user_token:
        user_token.delete()

    return Response({"message": "Successfully logged out."}, status=status.HTTP_200_OK)
