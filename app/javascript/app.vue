<template>
  <v-app id="app">

    <v-container style="height: 1000px; max-width: 2400px;">
      <v-layout>
        <v-flex xs2 style="justify-content: center; padding: 0 15px">
          <p>category list</p>
        </v-flex>

        <v-flex xs7>
          <p>Bookmark 一覧</p>
          <v-layout>
            <v-flex row wrap style="justify-content: center;">

              <v-card v-for="bookmark in bookmarks" :key="bookmark.id" style="margin: 10px 5px; width: 25%">
                <v-card-title primary-title>
                  <div>
                    <h3 class="headline mb-0">{{ bookmark.title }}</h3>
                    <hr>
                    <div>{{ bookmark.category }}</div>
                  </div>
                </v-card-title>
                <v-card-actions>
                  <v-btn dark @click="deleteBookmark(bookmark.id)">DELETE</v-btn>
                </v-card-actions>
              </v-card>
            </v-flex>
          </v-layout>

        </v-flex>
        <v-flex xs3 style="padding: 30px 30px;">
          <small>Bookmark 追加Form</small>
          
            <v-text-field
              v-model="postTitle"
              :counter="20"
              label="Title"
              required
            ></v-text-field>

            <v-text-field
              v-model="postUrl"
              label="URL"
              required
            ></v-text-field>

            <v-text-field
              v-model="postCategory"
              label="Category"
              required
            ></v-text-field>

            <!-- <v-select
              v-model="select"
              :items="items"
              :rules="[v => !!v || 'Item is required']"
              label="Category[select]"
              required
            ></v-select> -->

            <v-btn @click="postBookmark">submit</v-btn>
        </v-flex>
      </v-layout>
    </v-container>
  </v-app> 
</template>

<script>
import axios from 'axios';

export default {
  data: function () {
    return {
      bookmarks: "bookmarks",
      postTitle: "",
      postUrl: "",
      postCategory: "",
    }
  },
  mounted () {
    this.setBookmark();
  },
  methods: {
    setBookmark: function () {
      axios.get('/api/bookmarks')
      .then(response => (
        this.bookmarks = response.data
      ))
    },
    postBookmark: function() {
      axios.post('/api/bookmarks', {title:this.postTitle,url:this.postUrl,category:this.postCategory})
        .then(response => {
          this.setBookmark();
          this.postTitle = ''
          this.postUrl = ''
          this.postCategory = ''
        }
      );
    },
    deleteBookmark(id) {
      if (confirm("このBookmarkを削除しますか？")) {
        axios.delete(`/api/bookmarks/${id}`)
          .then(response => {
            this.setBookmark();
          }
        );
      }
      
    },
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
