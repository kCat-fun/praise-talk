<script setup lang="ts">
import { ref } from "vue";
import applause_path from "./assets/sounds/applause.mp3";
import laugh_path from "./assets/sounds/laugh.wav";

const applause = new Audio(applause_path);
const laugh = new Audio(laugh_path);

const selected = ref<"拍手" | "笑い声" | null>("拍手");
const status = ref(false);
const isRecognizing = ref(false); // 音声認識中かどうかのフラグ

const toggle = (value: "拍手" | "笑い声") => {
  selected.value = selected.value === value ? null : value;
};

const startStop = () => {
  if (status.value) {
    console.log("Stop");
    status.value = false;
    recognition.stop(); // 音声認識を停止
    isRecognizing.value = false;
  } else {
    console.log("Start");
    status.value = true;
    startPraise();
  }
};

// 音声認識の初期化
const SpeechRecognition = (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;
const recognition = new SpeechRecognition();
recognition.lang = 'ja-JP';
recognition.interimResults = false;
recognition.continuous = true;

const startPraise = () => {
  if (isRecognizing.value) {
    console.log("音声認識はすでに開始されています。");
    return;
  }
  isRecognizing.value = true;

  try {
    recognition.start();

    recognition.onresult = (event: any) => {
      if (selected.value === "拍手") {
        applause.play();
      } else if (selected.value === "笑い声") {
        laugh.play();
      }
    };

    recognition.onend = () => {
      console.log("音声認識が終了しました。");
      isRecognizing.value = false;

      if (status.value) {
        if (!isRecognizing.value) {
          recognition.start();
          isRecognizing.value = true;
        }
      }
    };

    recognition.onerror = (event: any) => {
      console.error("音声認識エラー:", event);
      isRecognizing.value = false;

      if (event.error === "no-speech") {
        console.warn("音が検出されませんでした。再試行します...");
        recognition.stop(); // 一旦停止
        setTimeout(() => {
          if (status.value && !isRecognizing.value) {
            recognition.start(); // 1秒後に再試行
            isRecognizing.value = true;
          }
        }, 1000);
      } else {
        alert("音声認識エラーが発生しました: " + event.error);
      }
    };
  } catch (error) {
    console.error("音声認識の開始に失敗:", error);
    alert("音声認識の開始に失敗しました。");
  }
};
</script>

<template>
  <div>
    <h1>褒めトーク</h1>
    <p>何をしゃべっても拍手か笑い声が返ってきます。</p>
    <div class="checkbox-container">
      <div>
        <input type="checkbox" :checked="selected === '拍手'" @change="toggle('拍手')" />
        <label>拍手</label>
      </div>
      <div>
        <input type="checkbox" :checked="selected === '笑い声'" @change="toggle('笑い声')" />
        <label>笑い声</label>
      </div>
    </div>
    <div class="status">
      Status: {{ status ? "Running" : "Stopped" }}
    </div>
    <div>
      <button @click="startStop">{{ status ? "Stop" : "Start" }}</button>
    </div>
  </div>
</template>

<style scoped>
.checkbox-container {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 16px;
}

.status {
  margin: 16px auto;
}
</style>
