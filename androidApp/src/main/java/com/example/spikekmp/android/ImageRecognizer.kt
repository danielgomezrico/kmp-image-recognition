package com.example.spikekmp.android

import android.graphics.Bitmap
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import java.util.concurrent.CompletableFuture


class ImageRecognizer {
    fun recognize(selectedImage: Bitmap): CompletableFuture<String> {
        val completable = CompletableFuture<String>()

        val recognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS)
        val image = InputImage.fromBitmap(selectedImage, 0)

        recognizer.process(image)
            .addOnSuccessListener { completable.complete(it.text) }
            .addOnFailureListener(completable::completeExceptionally)

        return completable
    }
}