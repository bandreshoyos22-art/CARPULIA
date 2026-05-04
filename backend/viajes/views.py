from rest_framework import viewsets
from .models import Viaje
from .serializers import ViajeSerializer

class ViajeViewSet(viewsets.ModelViewSet):
    queryset = Viaje.objects.all()
    serializer_class = ViajeSerializer
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import ListaEspera

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def unirse_lista_espera(request, viaje_id):
    try:
        viaje = Viaje.objects.get(id=viaje_id)
    except Viaje.DoesNotExist:
        return Response({"error": "Viaje no encontrado"}, status=404)

    if viaje.cupos_disponibles > 0:
        return Response({"error": "El viaje aún tiene cupos disponibles"})

    if ListaEspera.objects.filter(viaje=viaje, pasajero=request.user).exists():
        return Response({"error": "Ya estás en la lista de espera"})

    entrada = ListaEspera.objects.create(viaje=viaje, pasajero=request.user)
    posicion = ListaEspera.objects.filter(
        viaje=viaje,
        fecha_solicitud__lte=entrada.fecha_solicitud
    ).count()

    return Response({
        "mensaje": "Te agregamos a la lista de espera",
        "posicion": posicion
    })
