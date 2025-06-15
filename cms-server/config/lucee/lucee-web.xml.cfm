<?xml version="1.0" encoding="UTF-8"?>
<cfLuceeConfiguration version="6.0">
    <system err="default" out="null"/>
    <mappings>
        <mapping physical="{web-root-directory}/components" virtual="/components"/>
    </mappings>
    <custom-tag>
        <mapping inspect-template="never" physical="{lucee-config}/customtags/"/>
    </custom-tag>
    <component base="/lucee/Component.cfc" data-member-default-access="public" dump-template="/lucee/component-dump.cfm">
        <mapping inspect-template="never" physical="{lucee-web}/components/" primary="physical" virtual="/default"/>
    </component>
</cfLuceeConfiguration>
