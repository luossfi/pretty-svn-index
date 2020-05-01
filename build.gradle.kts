plugins {
  base
  distribution
}

tasks {
  val compileSass by registering(Exec::class) {
    description = "Compiles Sass sources."

    val sassSrc = file("src/scss")
    val sassDest = file("src/css")
    val cumstomizedScss = file("$sassSrc/pretty-svn-index-customized.scss")
    val prettySvnIndexScss = if (cumstomizedScss.exists()) "pretty-svn-index-customized.scss" else "pretty-svn-index.scss"

    val customSassExecutable = project.findProperty("sass.executable")
    if (customSassExecutable != null)
    {
      executable(file(customSassExecutable))
    }
    else
    {
      executable("sass")
    }

    val isDebug = project.hasProperty("sass.debug")
    if (isDebug)
    {
      args("--source-map", "--embed-source-map", "--style=expanded")
    }
    else
    {
      args("--no-source-map", "--style=compressed")
    }

    args(
      "$sassSrc/$prettySvnIndexScss:$sassDest/pretty-svn-index.css",
      "$sassSrc/fontawesome-free.scss:$sassDest/fontawesome-free.css",
      "$sassSrc/fonts.scss:$sassDest/fonts.css",
      "$sassSrc/normalize.scss:$sassDest/normalize.css"
    )

    inputs.dir(sassSrc)
    inputs.property("debug", isDebug)
    outputs.dir(sassDest)
  }

  withType(AbstractArchiveTask::class).configureEach {
    dependsOn(compileSass)
  }

  named<Sync>("installDist") {
    dependsOn(compileSass)
  }

  named<Delete>("clean") {
    delete("src/css")
  }
}

distributions {
  main {
    contents {
      from("src") {
        include("pretty-svn-index.xsl", "css/**", "webfonts/**")
      }

      from("licenses") {
        into("licenses/")
      }

      from("COPYING") {
        rename {"LICENSE.txt"}
        into("licenses/${project.name}-${project.version}/")
      }
    }
  }
}
