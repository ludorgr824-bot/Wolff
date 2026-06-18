# Wolff
#!/usr/bin/env bash
set -euo pipefail

# Usage: ./create_and_push_wolff.sh
# Prérequis: git configuré et accès push sur https://github.com/ludorgr824-bot/Wolff
# Exécutez dans un dossier où vous voulez créer le projet.

REPO_URL="https://github.com/ludorgr824-bot/Wolff.git"
DIR="Wolff"

if [ -d "$DIR" ]; then
  echo "Le dossier $DIR existe déjà. Supprimez-le ou choisissez un autre emplacement."
  exit 1
fi

mkdir -p "$DIR"
cd "$DIR"

# init git
git init
git checkout -b main

# settings.gradle
cat > settings.gradle <<'G'
rootProject.name = "Wolff"
include ':app'
G

# root build.gradle
cat > build.gradle <<'G'
// Top-level build file
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.0'
    }
}
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
G

# app/build.gradle
mkdir -p app
cat > app/build.gradle <<'G'
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'

android {
    namespace 'com.example.wolff'
    compileSdk 34

    defaultConfig {
        applicationId "com.example.wolff"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "0.1"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    implementation 'androidx.core:core-ktx:1.12.0'
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation "org.jetbrains.kotlin:kotlin-stdlib:1.9.0"
}
G

# AndroidManifest
mkdir -p app/src/main
cat > app/src/main/AndroidManifest.xml <<'G'
<manifest package="com.example.wolff" xmlns:android="http://schemas.android.com/apk/res/android">
  <uses-permission android:name="android.permission.INTERNET"/>

  <application
      android:label="Wolff"
      android:allowBackup="true"
      android:usesCleartextTraffic="true"
      android:supportsRtl="true">
      <activity android:name=".MainActivity"
                android:exported="true">
          <intent-filter>
              <action android:name="android.intent.action.MAIN" />
              <category android:name="android.intent.category.LAUNCHER" />
          </intent-filter>
      </activity>
  </application>
</manifest>
G

# MainActivity.kt
mkdir -p app/src/main/kotlin/com/example/wolff
cat > app/src/main/kotlin/com/example/wolff/MainActivity.kt <<'G'
package com.example.wolff

import android.annotation.SuppressLint
import android.os.Bundle
import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.activity.ComponentActivity

class MainActivity : ComponentActivity() {
    private lateinit var webView: WebView

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        webView = WebView(this)
        setContentView(webView)

        webView.settings.javaScriptEnabled = true
        webView.settings.allowFileAccess = true
        webView.settings.allowFileAccessFromFileURLs = true
        webView.settings.allowUniversalAccessFromFileURLs = true

        webView.webChromeClient = WebChromeClient()
        webView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?) = false
        }

        webView.loadUrl("file:///android_asset/tiktohai.html")
    }

    override fun onBackPressed() {
        if (this::webView.isInitialized && webView.canGoBack()) {
            webView.goBack()
        } else {
            super.onBackPressed()
        }
    }
}
G

# styles.xml
mkdir -p app/src/main/res/values
cat > app/src/main/res/values/styles.xml <<'G'
<resources>
  <style name="Theme.Wolff" parent="Theme.MaterialComponents.DayNight.NoActionBar">
  </style>
</resources>
G

# assets html
mkdir -p app/src/main/assets
cat > app/src/main/assets/tiktohai.html <<'G'
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Tiktohai — Contrôles</title>
  <style>
    body{font-family:system-ui,-apple-system,Roboto,Arial;max-width:800px;margin:16px auto;padding:8px}
    input{width:100%;padding:8px;margin:8px 0;border:1px solid #ccc;border-radius:6px}
    button{padding:10px 14px;margin:6px 6px 6px 0;border-radius:8px;border:0;background:#1976d2;color:#fff}
    pre{background:#f6f8fa;padding:10px;border-radius:6px;white-space:pre-wrap}
    small{color:#666}
  </style>
</head>
<body>
  <h2>Tiktohai — contrôles rapides</h2>

  <label>URL du serveur (ex : https://abcd.loca.lt ou http://127.0.0.1:3000)</label>
  <input id="url" placeholder="http://127.0.0.1:3000" value="http://127.0.0.1:3000">

  <div>
    <button onclick="health()">Health</button>
    <button onclick="createJob()">Créer job test</button>
    <button onclick="promptJob()">Créer job (prompt)</button>
  </div>

  <div style="margin-top:10px;">
    <label>Job ID à vérifier</label>
    <input id="jobId" placeholder="Collez jobId ici pour vérifier">
    <button onclick="checkJob()">Vérifier job</button>
  </div>

  <h3>Résultat</h3>
  <pre id="out">Aucune action pour l'instant.</pre>
  <small>Remarque : le serveur doit être accessible et répondre à /api/health et /api/generate. Le serveur doit accepter CORS (le serveur fourni le fait).</small>

<script>
function setOut(t){ document.getElementById('out').textContent = typeof t === 'string' ? t : JSON.stringify(t, null, 2); }
function getBase(){ return document.getElementById('url').value.replace(/\/+$/,''); }

async function health(){
  const base = getBase();
  try {
    const r = await fetch(base + '/api/health');
    const j = await r.json();
    setOut(j);
  } catch(e){ setOut('Erreur: ' + e); }
}

async function createJob(){
  const base = getBase();
  const body = { prompt: "Test depuis le navigateur", language: "fr" };
  try {
    const r = await fetch(base + '/api/generate', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    });
    const j = await r.json();
    setOut({ action: 'create', response: j });
    if (j.jobId) document.getElementById('jobId').value = j.jobId;
  } catch(e){ setOut('Erreur: ' + e); }
}

async function promptJob(){
  const p = prompt('Entrez le prompt pour le job:', 'Explique la recette du pain');
  if (!p) return;
  const base = getBase();
  const body = { prompt: p, language: "fr" };
  try {
    const r = await fetch(base + '/api/generate', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    });
    const j = await r.json();
    setOut({ action: 'create', response: j });
    if (j.jobId) document.getElementById('jobId').value = j.jobId;
  } catch(e){ setOut('Erreur: ' + e); }
}

async function checkJob(){
  const base = getBase();
  const id = document.getElementById('jobId').value.trim();
  if (!id) return setOut('Entrez un jobId.');
  try {
    const r = await fetch(base + '/api/job/' + encodeURIComponent(id));
    const j = await r.json();
    setOut(j);
    if (j.videoUrl) {
      setOut({ job: j, note: 'Cliquez sur le lien ci-dessous pour ouvrir la vidéo', videoUrl: j.videoUrl });
      // optionally make link clickable
      const out = document.getElementById('out');
      out.innerHTML = JSON.stringify(j, null, 2) + '\n\nVideoURL: ' + j.videoUrl + '\n\n(Ouvrez ce lien dans un onglet)';
    }
  } catch(e){ setOut('Erreur: ' + e); }
}
</script>
</body>
</html>
G

# GitHub Actions workflow
mkdir -p .github/workflows
cat > .github/workflows/build-apk.yml <<'G'
name: Build APK

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Install Android SDK (sdkmanager)
        uses: android-actions/setup-android@v2
        with:
          api-level: 33
          build-tools: '33.0.2'

      - name: Install Gradle
        run: |
          sudo apt-get update
          sudo apt-get install -y gradle

      - name: Build debug APK
        run: gradle assembleDebug --no-daemon

      - name: Upload debug APK
        uses: actions/upload-artifact@v4
        with:
          name: app-debug-apk
          path: app/build/outputs/apk/debug/app-debug.apk
G

# git add commit
git add .
git commit -m "Initial commit: Android project (Wolff) + workflow"
# add remote and push
git remote add origin "$REPO_URL" || true

# push to remote main
echo "Pushing to $REPO_URL (branch main). You may be prompted for credentials."
git push -u origin main

echo "Done. If push a échoué par permission, vérifiez que vous avez les droits sur le repo et que vous êtes authentifié."
