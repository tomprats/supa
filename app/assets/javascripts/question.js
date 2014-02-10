$(document).ready(function(){
  var statesdemo = {
    state0: {
      title: 'Handling',
      html:'<select name="handling">'+
          '<option value="Forehand or backhand">Only can throw a forehand or backhand</option>'+
          '<option value="Trouble when marked">Learning forehand and backhand but having trouble when marked</option>'+
          '<option value="Would rather cut">Comfortable throwing both but would rather cut</option>'+
          '<option value="Hammer time">It\'s hammer time</option>'+
          '<option value="Hucking">Can huck pretty accurately</option>'+
        '</select>',
      buttons: { Next: 1 },
      focus: 1,
      submit:function(e,v,m,f){
        e.preventDefault();
        $.prompt.goToState('state1');
      }
    },
    state1: {
      title: 'Cutting',
      html:'<select name="cutting">'+
          '<option value="Circles">I just run around</option>'+
          '<option value="Vertical stack">Vertical stack</option>'+
          '<option value="Both stacks">Vertical and horizontal stack</option>'+
          '<option value="Deep option">Don\'t know the stacks but can cut deep</option>'+
          '<option value="Stacks and deep">Know the stacks and can cut deep</option>'+
        '</select>',
      buttons: { Back: -1, Next: 1 },
      focus: 1,
      submit:function(e,v,m,f){
        if(v==1) $.prompt.goToState('state2')
        if(v==-1) $.prompt.goToState('state0');
        e.preventDefault();
      }
    },
    state2: {
      title: 'Defense',
      html:'<select name="defense">'+
          '<option value="Learning marking">Learning marking</option>'+
          '<option value="Learning stacking">Learning stack defense</option>'+
          '<option value="Learning zone">Learning zone defense</option>'+
          '<option value="Basics">Know the basics</option>'+
          '<option value="Above average">Above average</option>'+
          '<option value="Can shut down">Can shut Joe Prats down</option>'+
        '</select>',
      buttons: { Back: -1, Next: 1 },
      focus: 1,
      submit:function(e,v,m,f){
        if(v==1) $.prompt.goToState('state3')
        if(v==-1) $.prompt.goToState('state1');
        e.preventDefault();
      }
    },
    state3: {
      title: 'Fitness',
      html:'<select name="fitness">'+
          '<option value="Seriously injured">Seriously injured</option>'+
          '<option value="Athletically challenged">Athetically challenged</option>'+
          '<option value="Easily winded">Easily winded</option>'+
          '<option value="Average but out of shape">Average athlete but not currently in shape</option>'+
          '<option value="Average with regular exercise">Average athlete with regular exercise</option>'+
          '<option value="Serious athletic training">Serious athletic training</option>'+
        '</select>',
      buttons: { Back: -1, Next: 1 },
      focus: 1,
      submit:function(e,v,m,f){
        if(v==1) $.prompt.goToState('state4')
        if(v==-1) $.prompt.goToState('state2');
        e.preventDefault();
      }
    },
    state4: {
      title: 'Injuries',
      html:'<textarea name="injuries"></textarea>',
      buttons: { Back: -1, Next: 1 },
      focus: 1,
      submit:function(e,v,m,f){
        if(v==1) $.prompt.goToState('state5')
        if(v==-1) $.prompt.goToState('state3');
        e.preventDefault();
      }
    },
    state5: {
      title: 'Height',
      html:'<select name="height">'+
          '<option value="5\'2\" or shorter">5\'2\" or shorter</option>'+
          '<option value="5\'3\"">5\'3\"</option>'+
          '<option value="5\'4\"">5\'4\"</option>'+
          '<option value="5\'5\"">5\'5\"</option>'+
          '<option value="5\'6\"">5\'6\"</option>'+
          '<option value="5\'7\"">5\'7\"</option>'+
          '<option value="5\'8\"">5\'8\"</option>'+
          '<option value="5\'9\"">5\'9\"</option>'+
          '<option value="5\'10\"">5\'10\"</option>'+
          '<option value="5\'11\"">5\'11\"</option>'+
          '<option value="6\'0\"">6\'0\"</option>'+
          '<option value="6\'1\"">6\'1\"</option>'+
          '<option value="6\'2\"">6\'2\"</option>'+
          '<option value="6\'3\"">6\'3\"</option>'+
          '<option value="6\'4\" or taller">6\'4\" or taller</option>'+
        '</select>',
      buttons: { Back: -1, Next: 1 },
      focus: 1,
      submit:function(e,v,m,f){
        if(v==1) $.prompt.goToState('state6')
        if(v==-1) $.prompt.goToState('state4');
          e.preventDefault();
        }
      },
      state6: {
        title: "List club or college teams you've played for",
        html:'<textarea name="teams"></textarea>',
      buttons: { Back: -1, Next: 1 },
      focus: 1,
      submit:function(e,v,m,f){
        if(v==1) $.prompt.goToState('state7')
        if(v==-1) $.prompt.goToState('state5');
        e.preventDefault();
      }
    },
    state7: {
      title: 'Do you want to be a Co-captain?',
      html:'<label><input type="radio" name="cocaptain" value="Yes">Yes</label>'+
           '<label><input type="radio" name="cocaptain" value="No">No</label>',
      buttons: { Back: -1, Next: 1 },
      focus: 1,
      submit:function(e,v,m,f){
        if(v==1) $.prompt.goToState('state8')
        if(v==-1) $.prompt.goToState('state6');
        e.preventDefault();
      }
    },
    state8: {
      title: 'Previous roles on team',
      html:'<label><input type="checkbox" name="roles" value="Handler">Handler</label>'+
           '<label><input type="checkbox" name="roles" value="Cutter">Cutter</label>'+
           '<label><input type="checkbox" name="roles" value="Deep Cutter">Deep Cutter</label>',
      buttons: { Back: -1, Done: 1 },
      focus: 1,
      submit:function(e,v,m,f){
        e.preventDefault();
        if(v==1) {
          $(".jqiform").attr("action", "/questionnaire");
          $(".jqiform").attr("onsubmit", "return true");
          $(".jqiform").submit();
        }
        if(v==-1) $.prompt.goToState('state7');
      }
    }
  };

  $(".question").click(function(e) {
    e.preventDefault();
    $.prompt(statesdemo);
  });
});
