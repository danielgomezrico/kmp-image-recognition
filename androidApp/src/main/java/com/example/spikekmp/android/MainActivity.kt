package com.example.spikekmp.android

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import com.example.spikekmp.Greeting

class MainActivity : ComponentActivity() {
    val imageRecognizer = ImageRecognizer()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {
            MyApplicationTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    GreetingView("helo", imageRecognizer)
                }
            }
        }
    }
}

@Composable
fun GreetingView(text: String, imageRecognizer: ImageRecognizer) {
    val context = LocalContext.current
    val launcher =
        rememberLauncherForActivityResult(contract = ActivityResultContracts.GetContent()) { uri: Uri? ->
            uri?.let {
                val bitmap = getBitmapFromUri(context, uri)

                bitmap?.let {
                    imageRecognizer.recognize(bitmap).thenAccept { recognizedText ->
                        Toast.makeText(context, recognizedText, Toast.LENGTH_LONG).show()
                    }
                }
            }
        }

    ElevatedButton(onClick = {
        launcher.launch("image/*")
    }) {
        Text(text = "Select Image")
    }
}

fun getBitmapFromUri(context: Context, uri: Uri): Bitmap? {
    return context.contentResolver.openInputStream(uri)?.use { inputStream ->
        BitmapFactory.decodeStream(inputStream)
    }
}

@Preview
@Composable
fun DefaultPreview() {
    MyApplicationTheme {
        GreetingView("Hello, Android!", ImageRecognizer())
    }
}
