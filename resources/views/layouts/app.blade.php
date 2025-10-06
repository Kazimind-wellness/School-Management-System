@props(['title', 'metaDescription' => 'Default description for your site'])

<!doctype html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>{{ $title }}</title>
    <meta name="description" content="{{ $metaDescription }}">

    {{-- ✅ Classic CSS files --}}
    <link rel="stylesheet" href="{{ asset('css/bootstrap.css') }}">
    <link rel="stylesheet" href="{{ asset('css/font-awesome.css') }}">
    <link rel="stylesheet" href="{{ asset('css/jquery.fancybox.css') }}">
    <link rel="stylesheet" href="{{ asset('css/slick.css') }}">
    <link rel="stylesheet" href="{{ asset('css/style.css') }}">

    {{-- Optional Theme Colors (if used) --}}
    <link rel="stylesheet" href="{{ asset('css/theme-color/default-theme.css') }}">

    {{-- Google Fonts --}}
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap"
        rel="stylesheet">

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

    {{-- ✅ Classic JS files --}}
    <script src="{{ asset('js/jquery.min.js') }}"></script>
    <script src="{{ asset('js/bootstrap.js') }}"></script>
    <script src="{{ asset('js/waypoints.js') }}"></script>
    <script src="{{ asset('js/jquery.counterup.js') }}"></script>
    <script src="{{ asset('js/jquery.mixitup.js') }}"></script>
    <script src="{{ asset('js/jquery.fancybox.pack.js') }}"></script>
    <script src="{{ asset('js/slick.js') }}"></script>
    <script src="{{ asset('js/custom.js') }}"></script>

    {{-- Livewire Scripts --}}
    @livewireScripts

    {{-- AlpineJS --}}
    <script src="//unpkg.com/alpinejs" defer></script>

    {{-- Turbolinks Bridge (optional) --}}
    <script
        src="https://cdn.jsdelivr.net/gh/livewire/turbolinks@v0.1.x/dist/livewire-turbolinks.js"
        data-turbolinks-eval="false"
        data-turbo-eval="false">
    </script>
</body>
</html>
