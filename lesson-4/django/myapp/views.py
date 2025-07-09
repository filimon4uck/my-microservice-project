from django.http import HttpResponse
from django.db import connections
from django.db.utils import OperationalError


def home(request):
    return HttpResponse("Hello, this is the simplest Django app!")


def healthcheck(request):
    try:
        connections["default"].cursor()
        # return JsonResponse({"status": "ok", "db": "connected"})
        return HttpResponse("Database connection is Ok!")
    except OperationalError:
        return HttpResponse("Something went wrong with the database connection!")
        # return JsonResponse({"status": "error", "db": "not connected"}, status=500)
