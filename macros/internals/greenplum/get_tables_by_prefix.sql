{% macro get_tables_by_prefix(prefix) %}
     {{ return(adapter.dispatch('get_tables_by_prefix', 'tbls')(prefix=prefix)) }}
{% endmacro %}

{% macro greenplum__get_tables_by_prefix(prefix) %}
  {% set query %}
      select table_name
      from information_schema.tables
      where table_name like '{{ prefix }}%'
      and table_schema not in ('information_schema', 'pg_catalog')
      and table_type = 'BASE TABLE'
      order by table_name; 
  {% endset %}

  {% set results = run_query(query) %}
  {% do return(results.columns[0].values()) %}
{% endmacro %}

