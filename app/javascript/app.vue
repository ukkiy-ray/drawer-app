<template>
  <v-app id="app">

    <v-container style="height: 1000px; max-width: 2400px;">
      <v-layout>
        <v-flex xs2 style="justify-content: center; padding: 0 5px">
          <p>Bookmark List</p>
          <ul v-for="bookmark in bookmarks" :key="bookmark.id" style="list-style: none;">
            <li style="margin-top: 10px;"><a href="#">{{ bookmark.title }}</a></li>
            <hr>
          </ul>
        </v-flex>

        <v-flex xs8>
          <div style="width: 100%; margin: 5px 0 20px 0; display: flex; justify-content: center;">
            <p style="margin-right: 20px;">Bookmark 一覧</p>
            <v-btn @click="togglePostModal()">+ Bookmarkを追加する</v-btn>
          </div>
          
          <v-layout>
            <v-flex row wrap style="justify-content: center;">

              <v-card v-for="bookmark in bookmarks" :key="bookmark.id" style="margin: 10px 5px; width: 25%">
                <v-card-title primary-title>
                  <div>
                    <h3 class="headline mb-0">{{ bookmark.title }}</h3>
                    <hr>
                    <div>#{{ bookmark.category }}</div>
                  </div>
                </v-card-title>
                <v-card-actions>
                  <v-btn dark @click="deleteBookmark(bookmark.id)">削除</v-btn>
                </v-card-actions>
              </v-card>
            </v-flex>
          </v-layout>

        </v-flex>
        <v-flex xs2 style="padding: 30px 5px;">
          <small>Bookmark 追加Form</small>
          
            <v-text-field
              v-model="postTitle"
              :counter="50"
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

      <!-- 新規投稿用モーダルウィンドウ -->
        <v-dialog v-model="dialogPostFlag" width="400px" persistent>
          <v-card>
            <v-card-title class="headline blue-grey darken-3 white--text" primary-title>
              Create Form
            </v-card-title>

            <v-text-field v-model="postTitle" :counter="50" label="Title" required style='margin:20px;'></v-text-field> 
            <v-text-field v-model="postUrl" label="URL" required style='margin:20px;'></v-text-field> 
            <v-text-field v-model="postCategory" label="Category" required style='margin:20px;'></v-text-field> 

            <v-divider></v-divider>
            <v-card-actions>
              <v-btn dark @click="togglePostModal">
                Cancel
              </v-btn>
              <v-spacer></v-spacer>
              <v-btn @click="postBookmark">
                Add Bookmark
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>

    </v-container>
  </v-app> 
</template>

<script>
import axios from 'axios';

export default {
  data: function () {
    return {
      bookmarks: "bookmarks",
      dialogPostFlag: false,
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
    togglePostModal: function() {
      this.dialogPostFlag = !this.dialogPostFlag
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
      this.dialogPostFlag = !this.dialogPostFlag
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

a {
  text-decoration: none;
  color: #333;
}
</style>
