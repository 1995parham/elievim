local ls = require('luasnip')

local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node
local fmta = require('luasnip.extras.fmt').fmta

ls.add_snippets(nil, {
  go = {

    snip({
      trig = 'time_layout',
      namr = 'Time Standard Layout',
      dscr = 'The reference time, in numerical order',
    }, {
      text([[// Layout = "01/02 03:04:05PM '06 -0700" The reference time, in numerical order.]]),
    }),

    snip({
      trig = 'time_ansic',
      namr = 'Time ANSIC Layout',
      dscr = 'The reference time, in ANSIC layout',
    }, {
      text([[// ANSIC = "Mon Jan _2 15:04:05 2006"]]),
    }),

    snip({
      trig = 'time_unix',
      namr = 'Time Unix Layout',
      dscr = 'The reference time, in Unix layout',
    }, {
      text([[// UnixDate = "Mon Jan _2 15:04:05 MST 2006"]]),
    }),

    snip(
      {
        trig = 'config_with_koanf',
        namr = 'Provide configuration using Koanf',
        desr = 'Write down the code for loading configuration using koanf from default, TOML file and env',
      },
      fmta(
        [[
package config

import (
	"encoding/json"
	"log"
	"strings"

	"github.com/knadh/koanf/parsers/toml"
	"github.com/knadh/koanf/providers/env"
	"github.com/knadh/koanf/providers/file"
	"github.com/knadh/koanf/providers/structs"
	"github.com/knadh/koanf/v2"
	"github.com/tidwall/pretty"
)

// prefix indicates environment variables prefix.
const prefix = "<>_"

// Config holds all configurations.
type Config struct {
}

func Provide() Config {
	k := koanf.New(".")

	// load default configuration from default function
	if err := k.Load(structs.Provider(Default(), "koanf"), nil); err != nil {
		log.Fatalf("error loading default: %s", err)
	}

	// load configuration from file
	if err := k.Load(file.Provider("config.toml"), toml.Parser()); err != nil {
		log.Printf("error loading config.toml: %s", err)
	}

	// load environment variables
	if err := k.Load(
		// replace __ with . in environment variables so you can reference field a in struct b
		// as a__b.
		env.Provider(prefix, ".", func(source string) string {
			base := strings.ToLower(strings.TrimPrefix(source, prefix))

			return strings.ReplaceAll(base, "__", ".")
		}),
		nil,
	); err != nil {
		log.Printf("error loading environment variables: %s", err)
	}

	var instance Config
	if err := k.Unmarshal("", &instance); err != nil {
		log.Fatalf("error unmarshalling config: %s", err)
	}

	indent, err := json.MarshalIndent(instance, "", "\t")
	if err != nil {
		panic(err)
	}

	indent = pretty.Color(indent, nil)

	log.Printf(`
================ Loaded Configuration ================
%s
======================================================
	`, string(indent))

	return instance
}
    ]],
        { insert(1) }
      )
    ),
  },
})
