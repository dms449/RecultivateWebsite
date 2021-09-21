function addEvent(id, first, last, addr, hours=0.0, cost=0.0, notes=''){
  console.log(`${name}`);

  let st = `<div class="row py-1 g-3">
      <div class="col-md-2">${first} ${last}</div>
      <div class="col-md-3">${addr}</div>
      <div class="col-md-2"><input type="float" class="form-control" name=${id}hours value=${hours} required></div>
      <div class="col-md-2"><input type="float" class="form-control" name=${id}cost value=${cost} required></div>
      <div class="col-md-2"><input type="text" class="form-control" name=${id}notes value=${notes}></div>
      <div class="col-md-1"><button type="button">remove</button></div>
    </div>`;
      // <div class="col-3"><input type="text" class="form-control" value=${addr} readonly></div>
      // <div class="col-1"><input type="text" class="form-control" value=${name} readonly></div>
      // <div class="col-1"><input type="text" class="form-control" name="notes" value=""></div>
      // <div><input type="hidden" class="form-control" name="${id}lp_id" value=${property_id}></div>

  // var row = document.createRange().createContextualFragment(st)
  document.getElementById("eventsContainer").appendChild(
    document.createRange().createContextualFragment(st)
  );
  document.getElementById("property_ids").value += `${id} `;
}

function selectedGroup(group){
  $("#contractorContainer :input").each(function(e){
    this.checked = (group == this.dataset.groupid);
  });
}

// execute a change command 
$("select#group").change();

