@props(['title', 'metaDescription' => 'Default description for your site'])

<!doctype html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="{{ $metaDescription }}">

    {{-- Favicon --}}
    <link rel="icon" type="image/png" href="{{ asset('favicon.png') }}">

    {{-- Fonts --}}
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800;900&family=Quicksand:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    {{-- Styles --}}
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">
    @vite(['resources/css/app.css', 'resources/js/app.js'])

    {{-- Icons --}}
    <link href="https://unpkg.com/boxicons@2.1.1/css/boxicons.min.css" rel="stylesheet">

    {{-- Livewire Styles --}}
    @livewireStyles

    {{-- Utility for hiding Alpine until ready --}}
    <style>[x-cloak] { display: none !important; }</style>

    <title>{{ $title }}</title>
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
