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
        trig = 'koanf',
        namr = 'Koanf libraries',
        desr = 'Write down koanf libraries for loading env, struct and toml file',
      },
      fmta(
        [[
"github.com/knadh/koanf"
"github.com/knadh/koanf/parsers/toml"
"github.com/knadh/koanf/providers/env"
"github.com/knadh/koanf/providers/file"
"github.com/knadh/koanf/providers/structs"
        ]],
        {}
      )
    ),

    snip(
      {
        trig = 'koanf_load',
        namr = 'Koanf libraries',
        desr = 'Write down koanf libraries for loading env, struct and toml file',
      },
      fmta(
        [[
const (
	delimeter = "."
	seprator  = "__"

	// prefix indicates environment variables prefix.
	prefix = "<>_"

	upTemplate     = "================ Loaded Configuration ================"
	bottomTemplate = "======================================================"
)

// New reads configuration with koanf.
func New() *Config {
	k := koanf.New(".")

	// load default configuration from default function
	if err := k.Load(structs.Provider(Default(), "koanf"), nil); err != nil {
		log.Fatalf("error loading default: %s", err)
	}

	// load configuration from file
	if err := k.Load(file.Provider("config.toml"), toml.Parser()); err != nil {
		log.Printf("error loading config.toml: %s", err)
	}

	LoadEnv(k)

	var instance Config
	if err := k.Unmarshal("", &instance); err != nil {
		log.Fatalf("error unmarshalling config: %s", err)
	}

	log.Printf("%s\n%v\n%s\n", upTemplate, spew.Sdump(instance), bottomTemplate)

	return &instance
}

func LoadEnv(k *koanf.Koanf) {
	callback := func(source string) string {
		base := strings.ToLower(strings.TrimPrefix(source, prefix))

		return strings.ReplaceAll(base, seprator, delimeter)
	}

	// load environment variables
	if err := k.Load(env.Provider(prefix, delimeter, callback), nil); err != nil {
		log.Printf("error loading environment variables: %s", err)
	}
}
    ]],
        { insert(1) }
      )
    ),
  },
})
