import Sortable from 'sortablejs';
const initKanbanSortable = (ulElements) => {
  ulElements.forEach((ul) => {
    new Sortable(ul, {
        group: 'kanban', // set both lists to same group
        animation: 300
    });
  });
};
export { initKanbanSortable };