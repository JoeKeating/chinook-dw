{% macro generate_hashdiff(entity, fields) %}
    {{ dbt_utils.generate_surrogate_key(fields)}}
{% endmacro %}