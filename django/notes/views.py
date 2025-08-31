from django.shortcuts import render, redirect, get_object_or_404
from django.http import HttpRequest
from .models import Note

def list_create(request: HttpRequest):
    if request.method == 'POST':
        title = request.POST.get('title', '').strip()
        body = request.POST.get('body', '').strip()
        if title:
            Note.objects.create(title=title, body=body)
        return redirect('notes:list')
    notes = Note.objects.order_by('-created_at')
    return render(request, 'notes/list.html', {'notes': notes})

def delete(request: HttpRequest, note_id: int):
    note = get_object_or_404(Note, pk=note_id)
    if request.method == 'POST':
        note.delete()
        return redirect('notes:list')
    return render(request, 'notes/confirm_delete.html', {'note': note})