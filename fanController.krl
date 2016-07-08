ruleset fanController {
  meta {

    name "fan_controller"
    author "PicoLabs"
    description "General rules for Fan control"

    use module b507199x5 alias wrangler
    
    logging on
    
    sharing on
    provides fan_state
  }

  global {
    fan_state = function (){
      ent:fan_state;
    };
    //private
}

  rule fanOn {
    select when fan new_status where status eq "on"
    pre {}
   // if(ent:fan_state eq 0) then
    {
      http:put(ent:on_api);

    } // fan is off
    always {
      log "turning on fan @ " + ent:on_api;
      set ent:fan_state 1;
    }
  //  else {
  //    log "fan is already on."
  //  }
  }


  rule fanOff {
    select when fan new_status where status eq "off"
    pre {

      }
  //  if(ent:fan_state eq 1) then 
    {
      http:put(ent:off_api);// wont work with out https
    } // fan is on
    always {
      log "turning off fan @ " + ent:off_api;
      set ent:fan_state 0;
    }
  }

  rule updateApi {
    select when fan update_api
    pre {
      api_on = event:attr("api_on");
      api_off = event:attr("api_off");
      state = event:attr("state").defaultsTo(0,"defaulted To off");
      }
    {
     noop();
    }
    always {
      log "updateing api";
      set ent:fan_state state;
      set ent:on_api api_on;
      set ent:off_api api_off;
    }
  }

}