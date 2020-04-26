<template>
  <div>
    <div class = "category">
        <vui-button v-for="(amount, cat) in categories" :key="cat" v-on:click="current_cat = cat" v-bind:class="{ selected: current_cat == cat}">{{cat}} ({{amount}})</vui-button>
    </div>
    <hr>
    <table>
      <tr>
        <th>Blueprint</th>
        <th>Matter Required</th>
      </tr>
      <tr v-for="(data,index) in recipes" :key="index" v-show="showEntry(data)">
        <td>{{data.name}}</td>
        <td>{{data.matter}}</td>
        <td class="action">
          <vui-button icon="star">Print</vui-button> 
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
		data() {
    return this.$root.$data.state;
  },
  computed: {
    categories: function(){
      let st = Object.values(this.recipes).flatMap(s => s.category)
      let categories = {All: Object.values(this.recipes).length}
      st.filter((v, i, a) => a.indexOf(v) === i).forEach(cat => {
          categories[cat] = st.filter(t => t == cat).length
      })
      return categories
    }
  }, methods:{
    showEntry: function(data) {
      //return !data.categories.indexOf(this.current_cat) || this.current_cat == 'All'
      return true
    }
  }
};

</script>

<style lang="scss" scoped>
  table {
    width: 100%;
    th, td {
      text-align: left;
      width: auto;
      &.action {
        width: 1%;
        white-space: nowrap;
      }
    }
    th {
      font-weight: bold;
    }
  }
  .category {
    display: flex;
  }
</style>