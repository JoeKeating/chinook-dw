{% macro generate_sk(entity, fields) %}
    {{ dbt_utils.generate_surrogate_key(fields)}}
{% endmacro %}