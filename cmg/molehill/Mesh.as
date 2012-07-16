package cmg.molehill 
{
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	/**
	 * Holds mesh data including:
		 * vertex buffer
		 * index buffer
		 * materials 
		 * textures
	 * Object3D renders the mesh.
	 * @author ZenithSal
	 */
	public class Mesh 
	{
		protected var mVB:VertexBuffer3D = null;
		protected var mIB:IndexBuffer3D = null;
		
		public function Mesh() 
		{
			
		}
		
		public function createVB(vertices:Vector.<Number>, vertex_size:int):void
		{
			mVB = Molehill.context.createVertexBuffer(vertices.length / vertex_size, vertex_size);
			mVB.uploadFromVector(vertices, 0, vertices.length);
		}
		
		public function createIB(indices:Vector.<uint>):void
		{
			mIB = Molehill.context.createIndexBuffer(indices.length);
			mIB.uploadFromVector(indices, 0, indices.length);
		}
		
		public function setVB(vertex_buffer:VertexBuffer3D):void
		{
			mVB = vertex_buffer;
		}
		
		public function setIB(index_buffer:IndexBuffer3D):void
		{
			mIB = index_buffer;
		}
		
		public function get vertexBuffer():mVB
		{
			return mVB;
		}
		
		public function get indexBuffer():mIB
		{
			return mIB;
		}
	}

}