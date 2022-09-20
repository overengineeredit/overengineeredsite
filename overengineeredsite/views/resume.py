from django.http import HttpResponse
from django.shortcuts import render

class resume(object) : 
    @staticmethod
    def view(request):
        return render(request, 'resume.html', {})
