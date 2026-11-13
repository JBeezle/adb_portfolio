# Portfolio 5: Distributed and Cloud Database Exercise

Everything in the other portfolios runs on one PostgreSQL server and one MongoDB server on a single machine. For one clinic that is fine, but it has a weak point: if that machine goes down, nobody can book an appointment or look up a record. This is a short discussion of how Meridian would spread the database across more than one server if it needed to. None of it is set up in this project, it is a plan.

## Keeping a copy on another server

The first thing I would do is run a second server holding a live copy of the database. In PostgreSQL one server (the primary) takes all the writes, such as new bookings and diagnoses, and sends every change to a second server (a replica) that stays in step with it.

That copy helps in two ways. If the primary machine dies, the replica already has the data and can take over. And the heavy reports, like counting appointments per doctor, can run on the replica instead of the primary, so they do not slow down the front desk. The replica is usually a fraction of a second behind, which is fine for reports but means anything that has to see the latest booking should read from the primary.

## If the main server fails

If the primary goes down, a replica is promoted to become the new primary. There is a short pause while that happens, so it is quick but not instant. A connection pooler in front of the servers lets the application reconnect to the new primary without any change in the app.

One thing worth being clear about: a replica is not a backup. If someone deletes a patient by mistake, that delete copies to the replica too. So the clinic still needs proper backups, and backups are only trustworthy if they are tested by actually restoring them.

## Splitting the data

Sharding means splitting the data across servers so each one holds only part of it, instead of every server holding all of it. Meridian is one small clinic, so this is not needed; a primary with a replica is plenty. It would only matter if Meridian grew into many branches with very high volume. Then a natural way to split would be by branch, so each server holds whole branches and most queries stay on one server. That decision should come after looking at how the data is actually queried, not before.

## Consistency

On a single PostgreSQL server the data is always consistent: a booking either commits or it does not, which is the same commit and rollback as Portfolio 3. Once there are replicas they lag slightly behind the primary. Reports can live with that, but bookings cannot, so bookings always go to the primary where the rules are enforced.

## Running it in the cloud

Rather than set all this up by hand, Meridian could use managed cloud databases, for example a managed PostgreSQL service and MongoDB Atlas for the consultation documents. The provider handles the replicas, backups, encrypted connections and access control, and the clinic pays for it and depends on that provider.

## References

- PostgreSQL high availability and replication: <https://www.postgresql.org/docs/current/high-availability.html>
- MongoDB replication: <https://www.mongodb.com/docs/manual/replication/>
