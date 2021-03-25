<template>
  <div v-show="isLoading">
    <div class="fullview">
      <div class="loading-spacer"></div>
      <vue-loading 
        type="spiningDubbles"
        color="#2f8af0"
        :size="{ width: '100px', height: '100px' }"
        >
      </vue-loading>
    </div>
  </div>
</template>

<script>
import { VueLoading } from 'vue-loading-template'

export default {
  name: 'isLoading',
  data() {
    return {
      isLoading: true,
    }
  },
  components: {
    VueLoading,
  },

}
</script>

<style>
.fullview {
  width: 100%;
  height: 100%;
  background: rgba(254, 254, 254, 0.8);
  position: fixed;
  top: 60px;
  left: 0;
  z-index: 5;
}
.loading-spacer {
  height: 30%;
}
</style>