<template>
  <v-app id="app">
    <Loading v-show="isLoading"></Loading>
    <v-container style="height: 1000px; max-width: 2400px; padding: 0 20px;">
      <v-layout>
        <v-flex xs2 style="justify-content: center; padding: 20px 5px 0 5px">
          <h3>フリーワードで探す</h3>
          <v-text-field v-model="searchWord" @keyup="abstruct" label="Input Keyword" style='margin-top:4px'></v-text-field>
          <br>
          <h3>カテゴリーごとに絞る</h3>
          <v-select
            v-model='category'
            :items="categories"
            label="Category"
            v-on:change="abstruct">
          </v-select>
        </v-flex>

        <v-flex xs8>
          <div style="width: 100%; margin: 5px 0 20px 0; display: flex; justify-content: center;">
            <h1>Bookmark 一覧</h1>
          </div>
          
          <v-layout>
            <v-flex row wrap style="justify-content: center;">
              <draggable v-model="bookmarkList" style="margin: 0 25px; width: 80%; cursor: pointer;">
                <v-card v-for="bookmark in bookmarkList" :key="bookmark.id" style="width: 100%">
                  <v-card-title primary-title style="margin-bottom: 15px; width: 100%; padding-bottom: 10px;">
                    <div style="width: 100%;">
                      <div class="headline mb-0" style="display: flex; justify-content: space-between; width: 100%">
                        <a v-bind:href="bookmark.url" target="_blank" rel="noopener noreferrer" style="font-size: 18px;">
                          {{ bookmark.title }}
                        </a>
                        
                        <v-tooltip right>
                          <template v-slot:activator="{ on }">
                            <v-btn light v-on="on" @click="togglePutModal(bookmark.id)" style="margin-bottom: 8px">
                              <span class="material-icons" style="margin-right: 4px;">create</span>
                            </v-btn>
                          </template>
                          <span>編集する</span>
                        </v-tooltip>

                      </div>
                      <v-divider></v-divider>
                      <div style="font-size: 16px; display: flex; justify-content: space-between; width: 100%">
                        <div>#{{ bookmark.category }}</div>
                        
                        <v-tooltip right>
                          <template v-slot:activator="{ on }">
                            <v-btn dark v-on="on" @click="toggleDeleteModal(bookmark.id)" style="margin-top: 8px">
                              <span class="material-icons" style="margin-right: 4px;">delete</span>
                            </v-btn>
                          </template>
                          <span>削除する</span>
                        </v-tooltip>

                      </div>
                    </div>
                  </v-card-title>
                  <!-- <v-card-actions>
                    <v-btn dark @click="toggleDeleteModal(bookmark.id)">Delete</v-btn>
                  </v-card-actions> -->
                </v-card>
              </draggable>
            </v-flex>
          </v-layout>

        </v-flex>

        <v-flex xs2>
          <v-btn @click="togglePostModal()" style="margin: 20px 0 40px 0;">
            <span class="material-icons" style="margin-right: 4px;">add</span>Bookmarkを追加する
          </v-btn>
          <p style="margin-right: 30px">- Bookmark List -</p>
          <ul v-for="bookmark in bookmarkList" :key="bookmark.id" style="list-style: none; margin-right: 30px">
            <li style="margin-top: 10px;">
              <a v-bind:href="bookmark.url" target="_blank" rel="noopener noreferrer">{{ bookmark.title }}</a>
            </li>
            <hr>
          </ul>
        </v-flex>
      </v-layout>

      <!-- 新規投稿用モーダルウィンドウ -->
        <v-dialog v-model="dialogPostFlag" width="500px" persistent>
          <v-card>
            <v-card-title class="headline blue-grey darken-3 white--text" primary-title>
              Create Form
            </v-card-title>

            <v-text-field v-model="postTitle" :counter="50" label="Title" required style='margin:20px;'></v-text-field> 
            <v-text-field v-model="postUrl" label="URL" required style='margin:20px;'></v-text-field> 
            <v-text-field v-model="postCategory" :counter="50" label="Category" required style='margin:20px;'></v-text-field> 
            <v-select v-model='postCategory' :items="categoriesForEdit" label="Category [select]" style='margin:20px;'></v-select>

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

      <!-- 更新用モーダルウィンドウ -->
        <v-dialog v-model="dialogPutFlag" width="500px" persistent>
          <v-card>
            <v-card-title class="headline orange darken-4 white--text" primary-title>
              Edit Form
            </v-card-title>

            <v-text-field v-model="putTitle" :counter="50" label="Title" required style='margin:20px;'></v-text-field> 
            <v-text-field v-model="putUrl" label="URL" required style='margin:20px;'></v-text-field> 
            <v-text-field v-model="putCategory" :counter="50" label="Category" required style='margin:20px;'></v-text-field> 
            <v-select v-model='putCategory' :items="categoriesForEdit" label="Category [select]" style='margin:20px;'></v-select>

            <v-divider></v-divider>
            <v-card-actions>
              <v-btn dark @click="cancel">
                Cancel
              </v-btn>
              <v-spacer></v-spacer>
              <v-btn @click="putBookmark">
                Update
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>

        <!----------------------------------- 削除モーダル ------------------------------------------------>
        <v-dialog v-model="dialogDeleteFlag" width="400">
          <v-card>
            <v-card-title class="headline blue-grey darken-3 white--text" primary-title>
              Confirm
            </v-card-title>
            <br>
            <br>
            <v-card-text>
              <p>本当に削除してもよろしいですか？</p>
            </v-card-text>

            <v-divider></v-divider>

            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn dark class="yellow--text" @click="deleteBookmark()">
                Delete
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>

    </v-container>
  </v-app> 
</template>

<script>
import draggable from 'vuedraggable'
import Loading from './components/Loading'
import axios from 'axios';

export default {
  data: function () {
    return {
      isLoading: true,
      bookmarkList: ['',''],
      allData: ['',''],
      categories: ['All'],
      categoriesForEdit: [],
      category: 'ALL',

      bookmarks: "bookmarks",
      dialogPostFlag: false,
      postTitle: "",
      postUrl: "",
      postCategory: "",

      dialogPutFlag: false,
      putTitle: '',
      putUrl: '',
      putCategory: '',

      dialogDeleteFlag: false,
      searchWord: '',
    }
  },
  mounted () {
    axios.get("/api/bookmarks")
    .then(response => {
        this.allData = response.data;
        this.isLoading = false;
      }
    );
    this.setBookmark();
  },
  components: {
    Loading,
    draggable,
  },
  methods: {
    setBookmark: function () {
      axios.get('/api/bookmarks')
      .then(response => {
        // this.bookmarks = response.data

        this.allData = response.data
        this.bookmarkList = this.allData

        this.listCategories();
        this.abstruct();
        }
      );
    },

    listCategories: function() {
      this.categories = []
      this.categoriesForEdit = []
      this.categories.push('ALL')
      var i = 0;
      for (i=0; i<this.allData.length; i++) {
        if (this.categories.indexOf(this.allData[i].category) == -1) {
          this.categories.push(this.allData[i].category)
          this.categoriesForEdit.push(this.allData[i].category)
        }
      }
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
    togglePutModal: function(id) {
      this.id = id
      axios.get(`/api/bookmarks/${this.id}.json`)
        .then(response => {
          this.putTitle = response.data.title
          this.putUrl = response.data.url
          this.putCategory = response.data.category
        }
      );
      this.dialogPutFlag = !this.dialogPutFlag
    },
    putBookmark: function() {
      axios.put(`/api/bookmarks/${this.id}`, {title:this.putTitle, url:this.putUrl, category:this.putCategory})
        .then(response => {
          this.setBookmark();
        }
      );
      this.dialogPutFlag = !this.dialogPutFlag
    },
    cancel: function() {
      this.dialogPutFlag = !this.dialogPutFlag
    },

    deleteBookmark: function() {
      axios.delete(`/api/bookmarks/${this.id}`)
        .then(response => {
          this.setBookmark();
        }
      );
      this.dialogDeleteFlag = !this.dialogDeleteFlag
    },
    toggleDeleteModal: function(id) {
      this.id = id
      this.dialogDeleteFlag = !this.dialogDeleteFlag
    },

    abstruct: function() {
      var i = 0;

      if (this.category == 'ALL') {
        this.bookmarkList = []
        for (i=0; i<this.allData.length; i++) {
          if ((this.allData[i].title.indexOf(this.searchWord) !== -1) || (this.allData[i].category.indexOf(this.searchWord) !== -1)) {
            this.bookmarkList.push(this.allData[i])
          }
        }   
      } else if (this.category != '') { 
        this.bookmarkList = []
        for (i=0; i<this.allData.length; i++) {
          if (this.allData[i].category == this.category) {
            if ((this.allData[i].title.indexOf(this.searchWord) !== -1) || (this.allData[i].category.indexOf(this.searchWord) !== -1)) {
              this.bookmarkList.push(this.allData[i])
            }
          }
        }   
      }
    }


  }
}
</script>

<style scoped>
p {
  font-size: 20px;
  text-align: center;
}

a {
  text-decoration: none;
}
</style>
