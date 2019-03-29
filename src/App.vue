<template>
    <div id="app" class="container-fluid mt-5">
        <div class="row">
            <div class="col-12 col-sm-6">
                <img style="max-height: 20rem"
                     :src="`https://us-central1-futbol-cards.cloudfunctions.net/api/network/3/image/skin/${ethnicitiesClone.skin[0].substr(1)}/${ethnicitiesClone.skin[1]}/shadow/${ethnicitiesClone.shadow[0].substr(1)}/cheek/${ethnicitiesClone.cheek[0].substr(1)}/eye/${ethnicitiesClone.eye[0].substr(1)}/${ethnicitiesClone.eye[1]}/hair_top/${ethnicitiesClone.hair_top[0].substr(1)}/${ethnicitiesClone.hair_top[1]}/hair_bottom/${ethnicitiesClone.hair_bottom[0].substr(1)}/${ethnicitiesClone.hair_bottom[1]}/beard/${ethnicitiesClone.beard[0].substr(1)}/${ethnicitiesClone.beard[1]}/tache/${ethnicitiesClone.tache[0].substr(1)}/${ethnicitiesClone.tache[1]}/stubble/${ethnicitiesClone.stubble[0].substr(1)}/${ethnicitiesClone.stubble[1]}/kit/${kit}/colour/${colour}/name/${name}/position/${position}/average/${average}/tokenId/${tokenId}`"/>
            </div>
            <div class="col-12 col-sm-6">
                <hr/>

                <b-form v-if="niftyData">

                    <div class="row">
                        <div class="col">
                            <b-form-group id="name" label="Name:" label-for="name">
                                <b-form-input v-model="name" type="text"/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="position" label="Position:" label-for="position">
                                <b-form-input v-model="position" type="text"/>
                            </b-form-group>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <b-form-group id="average" label="Average:" label-for="average">
                                <b-form-input v-model="average" type="text"/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="tokenId" label="Token ID:" label-for="tokenId">
                                <b-form-input v-model="tokenId" type="text"/>
                            </b-form-group>
                        </div>
                    </div>

                    <hr/>

                    <div class="row">
                        <div class="col">
                            <b-form-group id="kit" label="Kit:" label-for="kit">
                                <b-form-select id="kit" :options="niftyData.kitOptions" required v-model="kit"/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="colours" label="Colours:" label-for="colours">
                                <b-form-select id="colours" :options="niftyData.coloursOptions" required v-model="colour"/>
                                <swatches v-model="niftyData.colours[colour].primary"></swatches>
                                <swatches v-model="niftyData.colours[colour].secondary"></swatches>
                                <swatches v-model="niftyData.colours[colour].tertiary"></swatches>
                            </b-form-group>
                        </div>
                    </div>

                    <hr/>

                    <div class="row">
                        <div class="col">
                            <b-form-group id="ethnicity" label="Ethnicity:" label-for="ethnicity">
                                <b-form-select id="ethnicity" :options="niftyData.ethnicitiesOptions" required v-model="ethnicity" v-on:change="ethnicitiesChange"/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="name" label="Name:" label-for="name">
                                <b-form-input v-model="ethnicitiesClone.name" type="text"/>
                            </b-form-group>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            Skin:
                            <b-form-input v-model="ethnicitiesClone.skin[0]" type="text"/>
                        </div>
                        <div class="col">
                            <b-form-input v-model="ethnicitiesClone.skin[1]" type="number"/>
                            <swatches v-model="ethnicitiesClone.skin[0]"></swatches>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            Shadow:
                            <b-form-input v-model="ethnicitiesClone.shadow[0]" type="text"/>
                        </div>
                        <div class="col">
                            <b-form-input v-model="ethnicitiesClone.shadow[1]" type="number"/>
                            <swatches v-model="ethnicitiesClone.shadow[0]"></swatches>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            Cheek:
                            <b-form-input v-model="ethnicitiesClone.cheek[0]" type="text"/>
                        </div>
                        <div class="col">
                            <b-form-input v-model="ethnicitiesClone.cheek[1]" type="text"/>
                            <swatches v-model="ethnicitiesClone.cheek[0]"></swatches>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            Eye:
                            <b-form-input v-model="ethnicitiesClone.eye[0]" type="text"/>
                        </div>
                        <div class="col">
                            <b-form-input v-model="ethnicitiesClone.eye[1]" type="text"/>
                            <swatches v-model="ethnicitiesClone.eye[0]"></swatches>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            Hair Top:
                            <b-form-input v-model="ethnicitiesClone.hair_top[0]" type="text"/>
                        </div>
                        <div class="col">
                            <b-form-input v-model="ethnicitiesClone.hair_top[1]" type="text"/>
                            <swatches v-model="ethnicitiesClone.hair_top[0]"></swatches>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            Hair Bottom:
                            <b-form-input v-model="ethnicitiesClone.hair_bottom[0]" type="text"/>
                        </div>
                        <div class="col">
                            <b-form-input v-model="ethnicitiesClone.hair_bottom[1]" type="text"/>
                            <swatches v-model="ethnicitiesClone.hair_bottom[0]"></swatches>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            Beard:
                            <b-form-input v-model="ethnicitiesClone.beard[0]" type="text"/>
                        </div>
                        <div class="col">
                            <b-form-input v-model="ethnicitiesClone.beard[1]" type="text"/>
                            <swatches v-model="ethnicitiesClone.beard[0]"></swatches>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            Tache:
                            <b-form-input v-model="ethnicitiesClone.tache[0]" type="text"/>
                        </div>
                        <div class="col">
                            <b-form-input v-model="ethnicitiesClone.tache[1]" type="text"/>
                            <swatches v-model="ethnicitiesClone.tache[0]"></swatches>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            Stubble:
                            <b-form-input v-model="ethnicitiesClone.stubble[0]" type="text"/>
                        </div>
                        <div class="col">
                            <b-form-input v-model="ethnicitiesClone.stubble[1]" type="number"/>
                            <swatches v-model="ethnicitiesClone.stubble[0]"></swatches>
                        </div>
                    </div>
                </b-form>

                <hr/>

                <pre class="small pre-scrollable ">
                    {{ JSON.parse(JSON.stringify(ethnicitiesClone)) }}
                </pre>

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
                name: 'Andy Gray',
                position: 'Midfield',
                average: 84,
                tokenId: 7983242,
                ethnicitiesClone: {
                    'name': 'Neville',
                    'skin': ['#E0AC69', 1],
                    'cheek': ['#D8A064', 1],
                    'shadow': ['#C68442', 1],
                    'eye': ['#000000', 1],
                    'hair_top': ['#8D5524', 0],
                    'hair_bottom': ['#8D5524', 0],
                    'beard': ['#8D5524', 0],
                    'tache': ['#8D5524', 1],
                    'stubble': ['#8D5524', 0],
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
            const res = await axios.get(`https://us-central1-futbol-cards.cloudfunctions.net/api/network/3/image/data`);
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
