from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from .models import (
    Viaje,
    Vehiculo,
    Rating,
    Perfil
)

from .serializers import (
    ViajeSerializer,
    VehiculoSerializer,
    RatingSerializer,
    PerfilSerializer
)


class ViajeViewSet(viewsets.ModelViewSet):

    queryset = Viaje.objects.all()
    serializer_class = ViajeSerializer



class VehiculoViewSet(viewsets.ModelViewSet):

    queryset = Vehiculo.objects.all()
    serializer_class = VehiculoSerializer
    permission_classes = [IsAuthenticated]



class RatingViewSet(viewsets.ModelViewSet):

    queryset = Rating.objects.all()
    serializer_class = RatingSerializer
    permission_classes = [IsAuthenticated]



class PerfilViewSet(viewsets.ModelViewSet):

    queryset = Perfil.objects.all()
    serializer_class = PerfilSerializer
    permission_classes = [IsAuthenticated]

    def perform_create(
        self,
        serializer
    ):

        serializer.save(
            usuario=self.request.user
        )