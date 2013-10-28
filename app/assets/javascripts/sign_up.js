$(document).ready(function ()
{
  
  var valid_fields = new Array(false, false, false, false, false);

  $("#user_first_name").on("change", function()
  {
    if ($(this).val() == "")
    {
      $('.first-name-error').fadeIn();
    }
    else
    {
      $('.first-name-error').fadeOut();
      valid_fields[0] = true;
    }
  });

  $("#user_last_name").on("change", function()
  {
    if ($(this).val() == "")
    {
      $('.last-name-error').fadeIn();
    }
    else
    {
      $('.last-name-error').fadeOut();
      valid_fields[1] = true;
    }
  });

  $("input[id=user_email]").on("change", function()
  {
    if (!($(this).val().toLowerCase().indexOf("virginia.edu") >= 0))
    {
      $('.email-error').fadeIn();
    }
    else
    {
      $('.email-error').fadeOut();
      valid_fields[2] = true;
    }
  });

  $("input[id=user_password]").on("change", function()
  {
    if ($(this).val().length < 8)
    {
      $('.password-error').fadeIn();
      $('.password-confirm-error').fadeOut();
    }
    else
    {
      $('.password-error').fadeOut();
      valid_fields[3] = true;

      if ($("input[id=user_password_confirmation").val() != "")
      {
        if(!checkPasswords())
        {
          $('.password-confirm-error').fadeIn();
        }
        else
        {
          $('.password-confirm-error').fadeOut();
          valid_fields[4] = true;
        }
      }
    }


  });

  $("input[id=user_password_confirmation]").on("change", function()
  {
    
    if (!checkPasswords())
    {
      $('.password-confirm-error').fadeIn();
    }
    else
    {
      $('.password-confirm-error').fadeOut();
      valid_fields[4] = true;
    }

  });

  $("#sign-up-button").on("click", function()
  {
    var check = true;

    for (var i = 0; i < 5; i++)
    {
      if (valid_fields[i] == false)
      {
        check = false;
      }
    }

    if (check)
    {
      $(this).form.submit();
    }
    else
    {
      if (!valid_fields[0])
      {
        $('.first-name-error').fadeIn();
      }
      if (!valid_fields[1])
      {
        $('.last-name-error').fadeIn();
      }
      if (!valid_fields[2])
      {
        $('.email-error').fadeIn();
      }
      if (!valid_fields[3])
      {
        $('.password-error').fadeIn();
      }
      if (!valid_fields[4])
      {
        $('.password-confirm-error').fadeIn();
      }
      return false;
    }

  });

  function checkPasswords() {
    var password = $("input[id=user_password]").val();
    var confirmPassword = $("input[id=user_password_confirmation]").val();

    if (password == confirmPassword){
      return true;
    }
    else{
      return false;
    }
  }


});