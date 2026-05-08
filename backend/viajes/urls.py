from rest_framework.routers import DefaultRouter
from .views import ViajeViewSet

router = DefaultRouter()
router.register(r'viajes', ViajeViewSet)

urlpatterns = router.urls