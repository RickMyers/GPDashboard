<div style="padding: 20px;">    
    <div style="width: 500px; margin-left: auto; margin-right: auto;">
        Member Add/Update and Form Generation
        <hr />
        <div style="float: left; width: 48%">
            <input type="hidden" v-model="health_plan_id" />
            <div class="vision-member-field">
                <input type="text" v-model="last_name" class="vision-member-input" />
            </div>
            <div class="vision-member-descriptor">
                Last Name
            </div>
            <div class="vision-member-field">
                <input type="text" v-model="first_name"  class="vision-member-input" />
            </div>
            <div class="vision-member-descriptor">
                First Name
            </div>
            <div class="vision-member-field">
                <input type="text" v-model="member_number" class="vision-member-input" />
            </div>
            <div class="vision-member-descriptor">
                Member ID
            </div>
            <div class="vision-member-field">
                <input type="text"  v-model="date_of_birth" class="vision-member-input" />
            </div>
            <div class="vision-member-descriptor">
                Date of Birth
            </div>   
            <div class="vision-member-field">
                <select v-model="gender" class="vision-member-input" >
                    <option value=""> </option>
                    <option value="M"> Male </option>
                    <option value="F"> Female </option>
                </select>
            </div>
            <div class="vision-member-descriptor">
                Gender
            </div>            
        </div>
        <div style="width: 48%; display: inline-block">
            <div class="vision-member-field">
                <input type="text" v-model="event_id" class="vision-member-input" />
            </div>
            <div class="vision-member-descriptor">
                Event ID
            </div>            
            <div class="vision-member-field">
                <input type="text" v-model="hba1c" class="vision-member-input" />
            </div>
            <div class="vision-member-descriptor">
                HBA1C
            </div>
            <div class="vision-member-field">
                <input type="text" v-model="hba1c_date" class="vision-member-input" />
            </div>
            <div class="vision-member-descriptor">
                HBA1C Date
            </div>
            <div class="vision-member-field">
                <input type="text" v-model="fbs" class="vision-member-input" />
            </div>
            <div class="vision-member-descriptor">
                FBS
            </div>        
            <div class="vision-member-field">
                <input type="text" v-model="fbs_date" class="vision-member-input" />
            </div>
            <div class="vision-member-descriptor">
                FBS Date
            </div>         
        </div>            
        <div style="clear: both"></div>
        <div class="vision-member-field">
            <table>
                <tr>
                    <td><input type="text" v-model="address" class="vision-member-input" style="width: 200px"  /></td>
                    <td><input type="text" v-model="city" class="vision-member-input" style="width: 100px"  /></td>
                    <td><input type="text" v-model="state" class="vision-member-input" style="width: 50px"  /></td>
                    <td><input type="text" v-model="zip_code" class="vision-member-input" style="width: 75px"  /></td>
                </tr>
                <tr>
                    <td class="vision-member-descriptor">Address</td>
                    <td class="vision-member-descriptor">City</td>
                    <td class="vision-member-descriptor">State</td>
                    <td class="vision-member-descriptor">Zip Code</td>
                </tr>                
            </table>
        </div>
        <div class="vision-member-field">
            <button @click="createNewMember()" > Save &amp; Generate </button>
        </div>        
    </div>
</div>