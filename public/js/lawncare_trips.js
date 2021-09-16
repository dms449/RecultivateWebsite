function addEvent(id, name, addr, hours=0.0, cost=0.0, notes=''){
  console.log(`${name}`);

  let st = `<div class="row py-1 g-3">
      <div class="col-1"><input type="text" class="form-control" value=name readonly></div>
      <div class="col-3"><input type="text" class="form-control" value=${addr} readonly></div>
      <div class="col-1"><input type="float" class="form-control" name=${id}hour value=${hours}></div>
      <div class="col-1"><input type="float" class="form-control" name=${id}cost value=${cost}></div>
      <div class="col-1"><input type="text" class="form-control" name="notes" value=""></div>
      <div class="col-1"><button type="button">remove</div>
      <div><input type="hidden" class="form-control" name="lp_id" value=${id}></div>
    </div>`;

  document.getElementById("eventsContainer").appendChild(
    document.createRange().createContextualFragment(st)
  );

}



