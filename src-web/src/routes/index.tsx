import { createRoute } from '@tanstack/react-router'
import { Route as rootRoute } from './__root'

export const Route = createRoute({
  getParentRoute: () => rootRoute,
  path: '/',
  component: Index,
})

function Index() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-gray-950">
      <h1 className="text-4xl font-bold text-white">Symposium</h1>
    </div>
  )
}
