<template>
    <div id="app" class="container">
        <h1 class="m-2">Nifty Football Builder</h1>
        <div class="row">
            <div class="col m-5">
                <img :src="`http://localhost:5000/futbol-cards/us-central1/api/network/5777/image/ethnicity/${ethnicity}/kit/${kit}/colour/${colour}`"/>
            </div>
            <div class="col">
                <b-form v-if="niftyData">
                    <b-form-group id="kit" label="Kit:" label-for="kit">
                        <b-form-select id="kit" :options="niftyData.kitOptions" required v-model="kit"/>
                    </b-form-group>
                    <b-form-group id="colours" label="Colours:" label-for="colours">
                        <b-form-select id="colours" :options="niftyData.coloursOptions" required v-model="colour"/>
                        <swatches v-model="niftyData.colours[colour].primary"></swatches>
                        <swatches v-model="niftyData.colours[colour].secondary"></swatches>
                        <swatches v-model="niftyData.colours[colour].tertiary"></swatches>
                    </b-form-group>
                    <b-form-group id="ethnicity" label="Ethnicity:" label-for="ethnicity">
                        <b-form-select id="ethnicity" :options="niftyData.ethnicitiesOptions" required v-model="ethnicity" v-on:change="ethnicitiesChange"/>
                        <hr/>
                        <div class="row">
                            <div class="col">Skin:</div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].skin[0]" type="text"/>
                            </div>
                            <div class="col">
                                <swatches v-model="niftyData.ethnicities[ethnicity].skin[0]"></swatches>
                            </div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].skin[1]" type="text"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col">Shadow:</div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].shadow[0]" type="text"/>
                            </div>
                            <div class="col">
                                <swatches v-model="niftyData.ethnicities[ethnicity].shadow[0]"></swatches>
                            </div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].shadow[1]" type="text"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col">Cheek:</div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].cheek[0]" type="text"/>
                            </div>
                            <div class="col">
                                <swatches v-model="niftyData.ethnicities[ethnicity].cheek[0]"></swatches>
                            </div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].cheek[1]" type="text"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col">Hair Top:</div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].hair_top[0]" type="text"/>
                            </div>
                            <div class="col">
                                <swatches v-model="niftyData.ethnicities[ethnicity].hair_top[0]"></swatches>
                            </div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].hair_top[1]" type="text"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col">Hair Bottom:</div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].hair_bottom[0]" type="text"/>
                            </div>
                            <div class="col">
                                <swatches v-model="niftyData.ethnicities[ethnicity].hair_bottom[0]"></swatches>
                            </div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].hair_bottom[1]" type="text"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col">Beard:</div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].beard[0]" type="text"/>
                            </div>
                            <div class="col">
                                <swatches v-model="niftyData.ethnicities[ethnicity].beard[0]"></swatches>
                            </div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].beard[1]" type="text"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col">Tache:</div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].tache[0]" type="text"/>
                            </div>
                            <div class="col">
                                <swatches v-model="niftyData.ethnicities[ethnicity].tache[0]"></swatches>
                            </div>
                            <div class="col">
                                <b-form-input v-model="niftyData.ethnicities[ethnicity].tache[1]" type="text"/>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col">Stubble:</div>
                            <!--<div class="col"><b-form-input v-model="niftyData.ethnicities[ethnicity].tache[0]" type="text"/></div>-->
                            <!--<div class="col"><swatches v-model="niftyData.ethnicities[ethnicity].tache[0]"></swatches></div>-->
                            <!--<div class="col"><b-form-input v-model="niftyData.ethnicities[ethnicity].tache[1]" type="text"/></div>-->
                        </div>

                        <div class="row">
                            <div class="col">Eye:</div>
                            <!--<div class="col"><b-form-input v-model="niftyData.ethnicities[ethnicity].tache[0]" type="text"/></div>-->
                            <!--<div class="col"><swatches v-model="niftyData.ethnicities[ethnicity].tache[0]"></swatches></div>-->
                            <!--<div class="col"><b-form-input v-model="niftyData.ethnicities[ethnicity].tache[1]" type="text"/></div>-->
                        </div>

                        <code class="small">
                            {{ ethnicitiesClone }}
                        </code>

                    </b-form-group>
                </b-form>
            </div>
        </div>
    </div>
</template>

<script>
    import axios from 'axios';
    import Swatches from 'vue-swatches';
    import 'vue-swatches/dist/vue-swatches.min.css';

    export default {
        name: 'app',
        data () {
            return {
                niftyData: null,
                ethnicity: 0,
                kit: 0,
                colour: 0,
                ethnicitiesClone: {
                    'name': 'Neville',
                    'skin': ['#E0AC69', 1],
                    'cheek': ['#D8A064', 1],
                    'shadow': ['#C68442', 1],
                    'hair_top': ['#8D5524', 0],
                    'hair_bottom': ['#8D5524', 0],
                    'beard': ['#8D5524', 0],
                    'tache': ['#8D5524', 1]
                },
            };
        },
        components: {
            Swatches
        },
        methods: {
            ethnicitiesChange (c) {
                console.log(c);
                this.ethnicitiesClone = this.niftyData.ethnicities[c];
            }
        },
        async created () {
            const res = await axios.get(`http://localhost:5000/futbol-cards/us-central1/api/network/5777/image/data`);
            this.niftyData = res.data;

            this.niftyData.kitOptions = [];
            this.niftyData.kits.forEach((k, i) => this.niftyData.kitOptions.push({value: i, text: k}));

            this.niftyData.coloursOptions = [];
            this.niftyData.colours.forEach((k, i) => this.niftyData.coloursOptions.push({value: i, text: k.name}));

            this.niftyData.ethnicitiesOptions = [];
            this.niftyData.ethnicities.forEach((k, i) => this.niftyData.ethnicitiesOptions.push({value: i, text: k.name}));
        }
    };
</script>

<style>
    #app {
        font-family: 'Avenir', Helvetica, Arial, sans-serif;
        color: #2c3e50;
    }

    .vue-swatches {
        display: inline-block;
    }
</style>
