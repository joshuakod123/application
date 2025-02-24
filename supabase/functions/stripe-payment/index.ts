import { serve } from "https://deno.land/std/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js";
import "https://deno.land/x/dotenv/load.ts";

// ✅ Set up environment variables
const STRIPE_SECRET = Deno.env.get("STRIPE_SECRET")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!;

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

serve(async (req) => {
  try {
    const body = await req.json();
    console.log("Received event:", body);

    // ✅ Handle Stripe payment success
    if (body.type === "checkout.session.completed") {
      const userId = body.data.object.metadata.user_id;

      // ✅ Update the user's subscription status in Supabase
      await supabase
        .from("users")
        .update({ is_premium: true })
        .eq("id", userId);

      console.log(`✅ Subscription activated for user: ${userId}`);
    }

    return new Response(JSON.stringify({ status: "success" }), { status: 200 });
  } catch (error) {
    console.error("❌ Error processing webhook:", error);
    return new Response(JSON.stringify({ error: "Webhook processing failed" }), { status: 400 });
  }
});
