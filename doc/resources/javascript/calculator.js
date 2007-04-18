function calc(form)
{
  var event = form.event.value;
  form.event.value = 'ajax';
	dojo.io.bind({
    encoding: "utf-8",
		formNode: form,
		mimetype: "text/html",
		load: function(type, data) { 
      dojo.byId('products').innerHTML = data;
      //dojo.dom.replaceChildren(, data);
    }
	});
  form.event.value = event;
}
