# TOO  BASIC  LFI  TOOL  DOCUMENTATION

Too Basic LFI tool is another stupid shell script to automate some boring repetitive commands. 

I'm not responsible for its use. Use it at your own risks. 

Trying to compromise systems you haven't been expressely authorized to is forbidden and may result in legal consequences.

## Main Features

I just noticed that there were no simple tool to discover relatively simple LFI without testing them one by one. 

This software is able to detect local file inclusions, using path traversal violation. 

Supported files (to increment): 


```
/etc/hosts

/etc/passwd

/etc/shadow

```

Supported files are automatically tested and displayed if found. 

LEVEL OF RECURSION 

You can control how deep will the software dive. Just remember that the deeper you're diving, less chances are to find what you're searching for.

## How to use it ? 

Specify the target : 

The first input parameter will always be considered as the URL you want to test. 

Choose the recursion level : 
```- r, -- recursion```

## Error messages you can possibly encounter in the jungle : 

``` Maybe you should think about having an actual connexion lmao (check your fucking interfaces man)```

You receive this message when the curl output a 0 or 408/greatest error code. 
This can happen for several reason, I let you investigate by trying a curl on the target ip. 

Most of the time this message is triggered when you have actually no connexion.
A ping never killed anyone. 


``` Server sets in no sniffing mode```

When you're asking for a server which methods are allowed it can sometimes tell you to fuck off. This is called no sniffing mode. 

How dare you try to spy on me ? 

``` Gotta dive deeper my friend ```

You can't drown in a cup of water. The precedent step of recursion was a failure.  Maybe the sea will be deeper. 

Also take a look at your soul while diving into the depths. 

