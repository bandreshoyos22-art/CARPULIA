from rest_framework import serializers

from .models import (
    Viaje,
    Vehiculo,
    Rating,
    Perfil
)


class ViajeSerializer(serializers.ModelSerializer):

    class Meta:
        model = Viaje
        fields = '__all__'


class VehiculoSerializer(serializers.ModelSerializer):

    class Meta:
        model = Vehiculo
        fields = '__all__'


class RatingSerializer(serializers.ModelSerializer):

    class Meta:
        model = Rating
        fields = '__all__'


class PerfilSerializer(serializers.ModelSerializer):

    class Meta:
        model = Perfil
        fields = '__all__'