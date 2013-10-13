$(document).on('page:load', function() {
  new App.GradeDonut('#grades', {
    width: 300,
    height: 300
  }).setData(gon.grades).render();
});