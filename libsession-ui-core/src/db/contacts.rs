use crate::db::query::{first_json_column_row_mapper, QueryInfo, SQLRunnable};
use crate::protos::ContactItem;

pub fn list_contacts_query(search: Option<String>) -> impl SQLRunnable<Item = ContactItem> {
    QueryInfo {
        name: "List contacts",
        //language=sqlite
        sql: r#"
            SELECT
                json_object(
                    'id', session_id,
                    'name', display_name,
                    'avatar', json(avatar)
                )
            FROM config_contacts
            WHERE nullif($1, '') IS NULL OR display_name LIKE '%' || $1 || '%'
            "#,
        params: (search,),
        row_mapper: first_json_column_row_mapper,
    }
}
