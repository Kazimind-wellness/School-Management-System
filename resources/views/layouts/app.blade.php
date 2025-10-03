@props(['title', 'metaDescription' => 'Default description for your site'])

<!doctype html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    {{-- ❌ Remove this line --}}
    {{-- <link rel="stylesheet" href="{{ asset('css/app.css') }}"> --}}

    {{-- ✅ Use Vite --}}
    @vite(['resources/css/app.css', 'resources/js/app.js'])

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <style>[x-cloak]{display:none !important;}</style>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link href='https://unpkg.com/boxicons@2.1.1/css/boxicons.min.css' rel='stylesheet'>
    <title>{{ $title }}</title>
    @livewireStyles
</head>


<body class="custom-scrollbar">
    <div x-data="{ menuOpen: false }" class="min-h-screen flex">
        {{-- Sidebar --}}
        @include('layouts.partials.sidebar')

        {{-- Main Content --}}
        <div class="lg:pl-64 w-full flex flex-col">
            {{-- Navbar --}}
            @include('layouts.partials.navbar')

            {{-- Page Content --}}
            {{ $slot }}
        </div>
    </div>

    {{-- Livewire Scripts --}}
    @livewireScripts

    {{-- AlpineJS (if not bundled in app.js) --}}
    <script src="//unpkg.com/alpinejs" defer></script>

    {{-- Livewire + Turbolinks Bridge --}}
    <script src="https://cdn.jsdelivr.net/gh/livewire/turbolinks@v0.1.x/dist/livewire-turbolinks.js"
            data-turbolinks-eval="false" data-turbo-eval="false"></script>
</body>
</html>
