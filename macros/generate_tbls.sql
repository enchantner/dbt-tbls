{% macro generate_tbls(h_prefix, l_prefix, s_prefix) %}

  {% set hubs = tbls.get_tables_by_prefix(h_prefix) %}
  {% set links = tbls.get_tables_by_prefix(l_prefix) %}
  {% set satellites = tbls.get_tables_by_prefix(s_prefix) %}

  {% set tbls_yaml = [] %}
  {% if target.type == 'greenplum' %}
    {% do tbls_yaml.append('dsn: postgres://' ~ target.user ~ ':PASSWORD_PLACEHOLDER@' ~ target.host ~ ':' ~ target.port ~ '/' ~ target.dbname ) %}
  {% else %}
    {% do tbls_yaml.append('dsn: ' ~ target.type ~ '://' ~ target.user ~ ':PASSWORD_PLACEHOLDER@' ~ target.host ~ ':' ~ target.port ~ '/' ~ target.dbname ) %}
  {% endif %}
  {% do tbls_yaml.append('include:') %}
  {% do tbls_yaml.append(' -' ~ h_prefix | lower ~ '*') %}
  {% do tbls_yaml.append(' -' ~ l_prefix | lower ~ '*') %}
  {% do tbls_yaml.append(' -' ~ s_prefix | lower ~ '*') %}
  {% do tbls_yaml.append('relations:') %}

  {% for hub in hubs %}
    {% do tbls_yaml.append(' - table: ' ~ hub) %}
  {% endfor %}

  {% set joined = tbls_yaml | join ('\n') %}
  {{ log(joined, info=True) }}
  {% do return(joined) %}
  
{% endmacro %}
