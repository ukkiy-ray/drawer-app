<template>
  <v-app id="app">

    <v-container style="height: 1000px; max-width: 2400px;">
      <v-layout>
        <v-flex xs2 style="justify-content: center; padding: 0 15px">
          <v-select
              v-model="category"
              :items="categories"
              label="Category"
            ></v-select>
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
                  <v-btn dark>DELETE</v-btn>
                </v-card-actions>
              </v-card>
            </v-flex>
          </v-layout>

        </v-flex>
        <v-flex xs3 style="padding: 30px 30px;">
          <small>Bookmark 追加Form</small>
          <v-form
            ref="form"
            v-model="valid"
            lazy-validation
          >
            <v-text-field
              v-model="title"
              :counter="20"
              :rules="nameRules"
              label="Title"
              required
            ></v-text-field>

            <v-text-field
              v-model="url"
              label="URL"
              required
            ></v-text-field>

            <v-text-field
              v-model="category"
              label="Category"
              required
            ></v-text-field>

            <v-select
              v-model="select"
              :items="items"
              :rules="[v => !!v || 'Item is required']"
              label="Category[select]"
              required
            ></v-select>

            <v-btn>submit</v-btn>
          </v-form>
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
      message: "Hello Vue!",
      bookmarks: "bookmarks"
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
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
