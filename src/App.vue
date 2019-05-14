<template>
    <div id="app" class="container-fluid mt-5">
        <div class="row">
            <div class="col-12 col-sm-6" v-if="chainId">
                <img style="max-height: 20rem"
                     :src="`${getRootApi()}/network/${chainId}/image/ethnicity/${ethnicity}/kit/${kit}/colour/${colour}/firstName/${firstName}/lastName/${lastName}/position/${position}/nationality/${nationality}`"/>

                <hr/>

                <b-button variant="danger" @click="mintPlayer" class="float-right m-5" size="lg">
                    Mint on {{ contracts.getNetwork(chainId).toUpperCase() }}
                </b-button>
            </div>
            <div class="col-12 col-sm-6">
                <b-form v-if="niftyData">

                    <div class="row">
                        <div class="col">
                            <b-form-group id="name" label="Name:" label-for="name">
                                <b-form-select v-model="firstName" :options="niftyData.firstNameOptions" required/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="name" label="Name:" label-for="name">
                                <b-form-select v-model="lastName" :options="niftyData.lastNameOptions" required/>
                            </b-form-group>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col">
                            <b-form-group id="nation" label="Nationality:" label-for="nation">
                                <b-form-select id="nation" :options="niftyData.nationalityOptions" required v-model="nationality"/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="position" label="Position:" label-for="position">
                                <b-form-select v-model="position" :options="niftyData.positionOptions" required/>
                            </b-form-group>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-2">
                            <b-form-group id="ethnicity" label="Ethnicity:" label-for="ethnicity">
                                <b-form-select id="ethnicity" :options="niftyData.ethnicitiesOptions" required v-model="ethnicity"/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="kit" label="Kit:" label-for="kit">
                                <b-form-select id="kit" :options="niftyData.kitOptions" required v-model="kit"/>
                            </b-form-group>
                        </div>
                        <div class="col">
                            <b-form-group id="colours" label="Colours:" label-for="colours">
                                <b-form-select id="colours" :options="niftyData.coloursOptions" required v-model="colour"/>
                            </b-form-group>
                        </div>
                    </div>

                </b-form>

                <hr/>

                <code>
                    nationality: {{nationality}}<br/>
                    position: {{position}}<br/>
                    ethnicity: {{ethnicity}}<br/>
                    kit: {{kit}}<br/>
                    colour: {{colour}}<br/>
                    firstName: {{firstName}}<br/>
                    lastName: {{lastName}}<br/>
                    to<br/>
                </code>


            </div>
        </div>
    </div>
</template>

<script>
    import axios from 'axios';
    import { ethers } from 'ethers';
    import { contracts, abi, getContractForNetworkAndAddress } from 'nifty-football-contract-tools';

    export default {
        name: 'app',
        data () {
            return {
                niftyData: null,
                nationality: 44,
                position: 3,
                ethnicity: 0,
                kit: 0,
                colour: 0,
                firstName: 0,
                lastName: 0,
                chainId: null,
                provider: null,
                signer: null,
                contracts: contracts,
            };
        },
        components: {},
        methods: {
            getRootApi () {
                // if (this.chainId === 5777) {
                //     return 'http://localhost:5000/futbol-cards/us-central1/main/api';
                // }
                // return 'https://niftyfootball.cards/api';

                return 'http://localhost:5000/futbol-cards/us-central1/main/api';
            },
            async mintPlayer () {

                // our default is mainnet so override
                const getNetworkString = (network) => {
                    return contracts.networkSplitter(network, {
                        mainnet: 'homestead',
                        ropsten: 'ropsten',
                        rinkeby: 'rinkeby',
                        local: 'homestead'
                    });
                };

                // FIXME add ABI to this call? Speak to James
                const value = 0; // this is admin and free!
                const addressObj = contracts.getNiftyFootballAdmin(contracts.getNetwork(this.chainId));

                const {address, abi} = getContractForNetworkAndAddress(contracts.getNetwork(this.chainId), addressObj.address);
                const niftyFootballAdminContract = new ethers.Contract(
                    address,
                    abi,
                    this.signer,
                );

                const gasPrice = await ethers.getDefaultProvider(getNetworkString(this.chainId)).getGasPrice();
                const gasLimit = await niftyFootballAdminContract.estimate.generateAndAssignCard(
                    this.nationality,
                    this.position,
                    this.ethnicity,
                    this.kit,
                    this.colour,
                    this.firstName,
                    this.lastName,
                    '0x377a75c4EF92502fE40D2b454f0C3829b8c0ffc5',
                    {value: value}
                );

                console.log('Price', gasPrice.toString());
                console.log('Limit', gasLimit.toString());

                let overrides = {
                    gasLimit: gasLimit.add(100000), // The maximum units of gas for the transaction to use
                    gasPrice: gasPrice,                     // The price (in wei) per unit of gas
                    value: value,
                };

                // wait for tx to be mined
                let tx = await niftyFootballAdminContract.generateAndAssignCard(
                    this.nationality,
                    this.position,
                    this.ethnicity,
                    this.kit,
                    this.colour,
                    this.firstName,
                    this.lastName,
                    '0x377a75c4EF92502fE40D2b454f0C3829b8c0ffc5',
                    overrides
                );

                let receipt = await tx.wait(1);
                console.log(`Rec:`, receipt);
            },
        },
        async created () {
            this.provider = new ethers.providers.Web3Provider(web3.currentProvider);
            this.signer = this.provider.getSigner();

            const {chainId} = await this.provider.getNetwork();
            this.chainId = chainId;

            const rootApi = await this.getRootApi();

            const res = await axios.get(`${rootApi}/network/${this.chainId}/image/data`);
            this.niftyData = res.data;

            // this could be better...I admit
            this.niftyData.kitOptions = [];
            Object.keys(this.niftyData.kits).forEach(
                (k, i) => this.niftyData.kitOptions.push({value: k, text: `${i} - ${this.niftyData.kits[k].name}`})
            );

            this.niftyData.coloursOptions = [];
            Object.keys(this.niftyData.colours).forEach(
                (k, i) => this.niftyData.coloursOptions.push({value: k, text: `${i} - ${this.niftyData.colours[k].name}`})
            );

            this.niftyData.nationalityOptions = [];
            Object.keys(this.niftyData.nations).forEach(
                (k) => this.niftyData.nationalityOptions.push({value: k, text: `${k} - ${this.niftyData.nations[k].name}`})
            );

            this.niftyData.ethnicitiesOptions = [];
            Object.keys(this.niftyData.nations[this.nationality].ethnicities).forEach(
                (k) => this.niftyData.ethnicitiesOptions.push({value: k, text: k})
            );

            this.niftyData.positionOptions = [];
            Object.keys(this.niftyData.positions).forEach(
                (k, i) => this.niftyData.positionOptions.push({value: this.niftyData.positions[k], text: `${i} - ${k}`})
            );

            this.niftyData.firstNameOptions = [];
            Object.keys(this.niftyData.nations[this.nationality].firstNames).forEach(
                (k) => this.niftyData.firstNameOptions.push({value: k, text: `${k} - ${this.niftyData.nations[this.nationality].firstNames[k].latin}`})
            );

            this.niftyData.lastNameOptions = [];
            Object.keys(this.niftyData.nations[this.nationality].lastNames).forEach(
                (k) => this.niftyData.lastNameOptions.push({value: k, text: `${k} - ${this.niftyData.nations[this.nationality].lastNames[k].latin}`})
            );
        }
    };
</script>

<style>
    #app {
        font-family: 'Avenir', Helvetica, Arial, sans-serif;
        color: #2c3e50;
    }
</style>
