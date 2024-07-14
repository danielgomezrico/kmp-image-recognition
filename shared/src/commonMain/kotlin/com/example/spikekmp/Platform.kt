package com.example.spikekmp

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform