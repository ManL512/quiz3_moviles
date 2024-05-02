#views.py
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth.models import User
from .serializers import UserSerializer
import os

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
        return Response({"error": "Por favor, ingrese el nombre de usuario y la contraseña."}, status=status.HTTP_400_BAD_REQUEST)

    user = User.objects.filter(username=username).first()
    if not user or not user.check_password(password):
        return Response({"error": "Credenciales inválidas"}, status=status.HTTP_400_BAD_REQUEST)

    refresh = RefreshToken.for_user(user)
    token = {
        'access': str(refresh.access_token),
    }

    return Response(token, status=status.HTTP_200_OK)

from django.core.signing import Signer

from django.core.signing import Signer

@api_view(['POST'])
def activate_long_token(request):
    username = request.data.get('username')
    password = request.data.get('password')

    if not username or not password:
        return Response({"error": "Por favor, ingrese el nombre de usuario y la contraseña."}, status=status.HTTP_400_BAD_REQUEST)

    user = User.objects.filter(username=username).first()
    if not user or not user.check_password(password):
        return Response({"error": "Credenciales inválidas"}, status=status.HTTP_400_BAD_REQUEST)

    refresh = RefreshToken.for_user(user)
    long_token = str(refresh.access_token)

    # Firmar el token de larga duración antes de guardarlo
    signer = Signer()
    signed_long_token = signer.sign(long_token)

    # Guardar la firma del token en un archivo
    with open('long_token.txt', 'w') as file:
        file.write(signed_long_token)

    return Response({"long_token": signed_long_token}, status=status.HTTP_200_OK)



@api_view(['POST'])
def long_token_login(request):
    username = request.data.get('username')
    long_token = request.data.get('long_token')

    if not username or not long_token:
        return Response({"error": "Por favor, ingrese el nombre de usuario y el token de larga duración."}, status=status.HTTP_400_BAD_REQUEST)

    user = User.objects.filter(username=username).first()
    if not user:
        return Response({"error": "Usuario no encontrado"}, status=status.HTTP_400_BAD_REQUEST)

    # Validar el token de larga duración aquí si es necesario

    # Puedes generar un nuevo token de acceso si el token de larga duración es válido
    refresh = RefreshToken(long_token)

    return Response({"access_token": str(refresh.access_token)}, status=status.HTTP_200_OK)

@api_view(['POST'])
def disable_long_token(request):
    username = request.data.get('username')
    password = request.data.get('password')

    if not username or not password:
        return Response({"error": "Por favor, ingrese el nombre de usuario y la contraseña."}, status=status.HTTP_400_BAD_REQUEST)

    user = User.objects.filter(username=username).first()
    if not user or not user.check_password(password):
        return Response({"error": "Credenciales inválidas"}, status=status.HTTP_400_BAD_REQUEST)

    # Eliminar el token de larga duración asociado al usuario
    user.long_token = None  # Suponiendo que tienes un campo llamado 'long_token' en tu modelo de usuario
    user.save()

    # Eliminar el archivo que contiene el token de larga duración
    file_path = 'long_token.txt'  # Ruta al archivo
    if os.path.exists(file_path):
        os.remove(file_path)

    return Response({"message": "Token de larga duración desactivado correctamente"}, status=status.HTTP_200_OK)
